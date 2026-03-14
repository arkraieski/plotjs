HTMLWidgets.widget({
  name: "plotjsScatter",
  type: "output",

  factory: function(el) {
    function renderChart(x) {
      var data = x.data;
      var helpers = window.plotjsWidgets;
      var datasets;
      var showLegend = data.grouped_data !== null;

      if (showLegend) {
        datasets = data.group_names.map(function(groupName, index) {
          var color = data.col_hex ? data.col_hex[index] : helpers.palette(index);
          return helpers.buildScatterDataset(
            groupName,
            data.grouped_data.x[groupName],
            data.grouped_data.y[groupName],
            color,
            data
          );
        });
      } else {
        datasets = [
          helpers.buildScatterDataset(
            data.ylab,
            data.x,
            data.y,
            data.col_hex || helpers.palette(0),
            data
          )
        ];
      }

      helpers.ensureChart(el, {
        type: "scatter",
        data: {
          datasets: datasets
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          animation: false,
          parsing: false,
          plugins: {
            title: {
              display: !!data.title,
              text: data.title || ""
            },
            legend: helpers.legendOptions(data.legend, showLegend, data.legend && data.legend.text),
            tooltip: {
              intersect: false
            },
            zoom: {
              pan: {
                enabled: false
              },
              zoom: {
                wheel: {
                  enabled: !!data.zoom
                },
                pinch: {
                  enabled: !!data.zoom
                },
                drag: {
                  enabled: !!data.zoom
                },
                mode: "xy"
              }
            }
          },
          scales: {
            x: {
              type: "linear",
              min: data.xlim ? data.xlim[0] : undefined,
              max: data.xlim ? data.xlim[1] : undefined,
              title: {
                display: !!data.xlab,
                text: data.xlab || ""
              },
              ticks: helpers.scientificTick(data.sci_x)
            },
            y: {
              min: data.ylim ? data.ylim[0] : undefined,
              max: data.ylim ? data.ylim[1] : undefined,
              title: {
                display: !!data.ylab,
                text: data.ylab || ""
              },
              ticks: helpers.scientificTick(data.sci_y)
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
