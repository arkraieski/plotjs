HTMLWidgets.widget({
  name: "jsbarplot",
  type: "output",

  factory: function(el) {
    function renderChart(x) {
      const helpers = window.plotjsWidgets;
      const labels = x.categories || x.height.map(function(_, index) {
        return String(index + 1);
      });
      const color = x.col || helpers.palette(0);

      helpers.ensureChart(el, {
        type: "bar",
        data: {
          labels: labels,
          datasets: [{
            label: x.ylab || "height",
            data: x.height,
            backgroundColor: x.height.map(function() {
              return color;
            }),
            borderColor: color,
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
            legend: {
              display: false
            }
          },
          scales: {
            x: {
              title: {
                display: false
              }
            },
            y: {
              beginAtZero: true,
              title: {
                display: !!x.ylab,
                text: x.ylab || ""
              }
            }
          }
        }
      }, x.aria_label);
    }

    return {
      renderValue: renderChart,
      resize: function(width, height) {
        window.plotjsWidgets.resizeChart(el, width, height);
      }
    };
  }
});
