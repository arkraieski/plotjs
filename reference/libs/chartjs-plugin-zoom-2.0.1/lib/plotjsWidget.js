(function() {
  function palette(index) {
    var colors = [
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

  function ensureChart(el, config) {
    destroyChart(el);
    el.innerHTML = "";
    var canvas = document.createElement("canvas");
    canvas.className = "plotjs-canvas";
    el.appendChild(canvas);
    var ctx = canvas.getContext("2d");
    el.plotjsChart = new Chart(ctx, config);
    return el.plotjsChart;
  }

  function destroyChart(el) {
    if (el.plotjsChart && typeof el.plotjsChart.destroy === "function") {
      el.plotjsChart.destroy();
    }
    el.plotjsChart = null;
  }

  function legendOptions(legend, show, title) {
    var visible = !!show && !(legend && legend.hide);
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
    var points = xValues.map(function(x, i) {
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

  var pieLabelPlugin = {
    id: "plotjsPieLabels",
    afterDatasetsDraw: function(chart, args, pluginOptions) {
      if (!pluginOptions || !pluginOptions.display) {
        return;
      }

      var meta = chart.getDatasetMeta(0);
      var dataset = chart.data.datasets[0];
      if (!meta || !dataset) {
        return;
      }

      var total = dataset.data.reduce(function(sum, value) {
        return sum + value;
      }, 0);

      var ctx = chart.ctx;
      ctx.save();
      ctx.fillStyle = pluginOptions.color || "#ffffff";
      ctx.font = pluginOptions.font || "12px sans-serif";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";

      meta.data.forEach(function(arc, index) {
        var value = dataset.data[index];
        if (!value) {
          return;
        }

        var position = arc.tooltipPosition();
        var label = pluginOptions.mode === "id"
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
    legendOptions: legendOptions,
    scientificTick: scientificTick,
    buildScatterDataset: buildScatterDataset
  };
})();
