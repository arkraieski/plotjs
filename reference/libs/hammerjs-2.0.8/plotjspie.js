HTMLWidgets.widget({
  name: "plotjspie",
  type: "output",

  factory: function(el) {
    function renderChart(x) {
      var helpers = window.plotjsWidgets;
      var colors = x.colors || x.labels.map(function(_, index) {
        return helpers.palette(index);
      });

      helpers.ensureChart(el, {
        type: "pie",
        data: {
          labels: x.labels,
          datasets: [{
            data: x.values,
            backgroundColor: colors,
            borderColor: "#ffffff",
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          animation: false,
          plugins: {
            title: {
              display: !!x.main,
              text: x.main || ""
            },
            legend: helpers.legendOptions(x.legend, !x.legend.hide, null),
            plotjsPieLabels: {
              display: true,
              mode: x.label_mode || "pct"
            }
          }
        }
      });
    }

    return {
      renderValue: renderChart,
      resize: function(width, height) {
        if (el.plotjsChart) {
          el.plotjsChart.resize(width, height);
        }
      }
    };
  }
});
