# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Project Overview

`plotjs` is an R package (previously `c3plot`) that provides a base R
`graphics`-like interface to the Chart.js JavaScript charting library
via `htmlwidgets`. Users can create interactive charts with minimal
syntax changes from base R plotting calls.

## Common Commands

``` r
# Load package for interactive development
devtools::load_all()

# Run all tests
devtools::test()

# Run tests for a specific file
testthat::test_file("tests/testthat/test-plotjsScatter.R")

# Regenerate documentation (man/ and NAMESPACE) from roxygen2 comments
devtools::document()

# Full package check (runs R CMD check)
devtools::check()
```

## Architecture

The package has two layers that must stay in sync:

### R Layer (`R/`)

- `plotjsScatter.R` — the
  [`plotjs()`](https://arkraieski.github.io/plotjs/reference/plotjs.md)
  S3 generic and all its methods (`default`, `density`, `function`,
  `lm`), plus the internal `plotjsScatter()` htmlwidget factory and
  Shiny bindings
- `jsbarplot.R` —
  [`jsbarplot()`](https://arkraieski.github.io/plotjs/reference/jsbarplot.md),
  the
  [`plotjs.factor()`](https://arkraieski.github.io/plotjs/reference/plotjs.factor.md)
  S3 method, and Shiny bindings
- `jspie.R` —
  [`jspie()`](https://arkraieski.github.io/plotjs/reference/jspie.md)
  for pie/donut charts and Shiny bindings
- `utils.R` — `col2hex()` (R color name → hex) and
  `plotjsSizingPolicy()` (htmlwidgets sizing wrapper)

Each R function builds a named list and calls
[`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html).
The widget name must match the `.js` file in `inst/htmlwidgets/`.

### JavaScript Layer (`inst/htmlwidgets/`)

- `plotjsScatter.js`, `jsbarplot.js`, `jspie.js` — individual
  HTMLWidgets bindings; each receives the serialized R list as `x` and
  configures a Chart.js instance
- `lib/plotjsWidget.js` — shared utilities used by all three widgets:
  color palette, `ensureChart`/`destroyChart`/`resizeChart`,
  `legendOptions`, `scientificTick`, `buildScatterDataset`, and the
  `pieLabelPlugin` custom Chart.js plugin
- `lib/chart.umd.min.js` — Chart.js v4.5.1 (bundled, do not upgrade
  without testing all chart types)
- `lib/chartjs-plugin-zoom.min.js` + `lib/hammer.min.js` — zoom/gesture
  support

### Data Flow

R serializes data →
[`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html)
→ JSON → JS widget `renderValue(el, x)` → `plotjsWidget.js` helpers →
Chart.js

## R API Stability

**Do not modify R source files (`R/`) unless explicitly asked.** API
stability is the primary goal. The public interface intentionally
mirrors base R `graphics` conventions (argument names, defaults, S3
dispatch patterns). When new R code is needed, follow the style of R’s
own graphics functions — terse argument names (`col`, `lty`, `lwd`,
`xlab`, `ylab`, `main`), `...` for extensibility, and S3 dispatch over
if/else branching on type.

## Key Conventions

- **S3 dispatch:** New plot types should be added as `plotjs.<class>()`
  methods in `plotjsScatter.R`, not as new top-level functions, unless
  the chart type is fundamentally different (bar, pie have their own
  files because they use separate Chart.js types).
- **Color handling:** R color names are converted to hex via `col2hex()`
  before being passed to JavaScript. Always use `col2hex()` when
  accepting user color arguments.
- **Documentation:** All exported functions use roxygen2 comments. Run
  `devtools::document()` after editing `@param`/`@export` tags — never
  edit `NAMESPACE` or `man/` directly.
- **Testing:** Tests use `testthat`. Snapshot tests live in
  `tests/testthat/_snaps/`. Test widget creation and the structure of
  the returned htmlwidget object, not rendered output.
