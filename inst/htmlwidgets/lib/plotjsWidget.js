(function() {
  function palette(index) {
    const colors = [
      "#4E79A7", "#F28E2B", "#E15759", "#76B7B2", "#59A14F",
      "#EDC948", "#B07AA1", "#FF9DA7", "#9C755F", "#BAB0AC"
    ];
    return colors[index % colors.length];
  }

  function legendPosition(position) {
    if (position === "inset") {
      return "chartArea";
    }
    return position || "right";
  }

  function ensureChart(el, config, ariaLabel) {
    destroyChart(el);
    el.innerHTML = "";
    const container = document.createElement("div");
    container.className = "plotjs-chart-container";
    container.style.position = "relative";
    container.style.width = "100%";
    container.style.height = "100%";
    const canvas = document.createElement("canvas");
    canvas.className = "plotjs-canvas";
    if (ariaLabel) {
      canvas.setAttribute("role", "img");
      canvas.setAttribute("aria-label", ariaLabel);
    }
    container.appendChild(canvas);
    el.appendChild(container);
    const ctx = canvas.getContext("2d");
    el.plotjsContainer = container;
    el.plotjsChart = new Chart(ctx, config);
    return el.plotjsChart;
  }

  function destroyChart(el) {
    if (el.plotjsChart && typeof el.plotjsChart.destroy === "function") {
      el.plotjsChart.destroy();
    }
    el.plotjsChart = null;
    el.plotjsContainer = null;
  }

  function resizeChart(el, width, height) {
    if (!el.plotjsChart || !el.plotjsContainer) {
      return;
    }

    if (typeof width === "number" && width >= 0) {
      el.style.width = width + "px";
      el.plotjsContainer.style.width = width + "px";
    } else {
      el.style.width = "";
      el.plotjsContainer.style.width = "100%";
    }

    if (typeof height === "number" && height >= 0) {
      el.style.height = height + "px";
      el.plotjsContainer.style.height = height + "px";
    } else {
      el.style.height = "";
      el.plotjsContainer.style.height = "100%";
    }

    el.plotjsChart.resize();
  }

  function legendOptions(legend, show, title) {
    const visible = !!show && !(legend && legend.hide);
    return {
      display: visible,
      position: legendPosition(legend && legend.position),
      labels: {
        boxWidth: 12,
        usePointStyle: false
      },
      title: {
        display: visible && !!title,
        text: title || ""
      }
    };
  }

  function scientificTick(enabled) {
    if (!enabled) {
      return {};
    }
    return {
      callback: function(value) {
        if (value === null || value === undefined) {
          return value;
        }
        return Number(value).toExponential();
      }
    };
  }

  function buildScatterDataset(label, xValues, yValues, color, data) {
    const points = xValues.map(function(x, i) {
      return { x: x, y: yValues[i] };
    }).filter(function(point) {
      return point.x !== null && point.y !== null && !isNaN(point.x) && !isNaN(point.y);
    });

    return {
      label: label,
      data: points,
      showLine: data.plot_type === "line",
      borderColor: color,
      backgroundColor: color,
      pointRadius: data.show_points ? 3 : 0,
      pointHoverRadius: data.show_points ? 4 : 0,
      pointHitRadius: 8,
      borderWidth: data.plot_type === "line" ? 2 : 1,
      tension: 0
    };
  }

  const pieLabelPlugin = {
    id: "plotjsPieLabels",
    afterDatasetsDraw: function(chart, args, pluginOptions) {
      if (!pluginOptions || !pluginOptions.display) {
        return;
      }

      const meta = chart.getDatasetMeta(0);
      const dataset = chart.data.datasets[0];
      if (!meta || !dataset) {
        return;
      }

      const total = dataset.data.reduce(function(sum, value) {
        return sum + value;
      }, 0);

      const ctx = chart.ctx;
      ctx.save();
      ctx.fillStyle = pluginOptions.color || "#ffffff";
      ctx.font = pluginOptions.font || "12px sans-serif";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";

      meta.data.forEach(function(arc, index) {
        const value = dataset.data[index];
        if (!value) {
          return;
        }

        const position = arc.tooltipPosition();
        const label = pluginOptions.mode === "id"
          ? chart.data.labels[index]
          : Math.round((value / total) * 100) + "%";

        ctx.fillText(label, position.x, position.y);
      });

      ctx.restore();
    }
  };

  function registerPlugins() {
    if (window.ChartZoom && !Chart.registry.plugins.get("zoom")) {
      Chart.register(window.ChartZoom);
    }
    if (!Chart.registry.plugins.get("plotjsPieLabels")) {
      Chart.register(pieLabelPlugin);
    }
  }

  registerPlugins();

  window.plotjsWidgets = {
    palette: palette,
    ensureChart: ensureChart,
    destroyChart: destroyChart,
    resizeChart: resizeChart,
    legendOptions: legendOptions,
    scientificTick: scientificTick,
    buildScatterDataset: buildScatterDataset
  };
})();
