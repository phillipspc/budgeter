import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    const chartData = JSON.parse(this.data.get("data"))
    const chartLabels = JSON.parse(this.data.get("labels"))
    let ctx = this.element

    if (this.data.has("type") && this.data.get("type") == "line") {
      let myChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: chartLabels,
          datasets: [{
            label: 'Spending',
            backgroundColor: this.colors(1),
            borderColor: this.colors(1),
            data: chartData,
            fill: false
          }]
        }
      })
    } else {
      let myChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: chartLabels,
          datasets: [{
            data: chartData,
            backgroundColor: this.colors(chartData.length)
          }]
        }
      })
    }
  }

  colors(num) {
    return [
              'rgba(255, 99, 132, 0.2)',
              'rgba(54, 162, 235, 0.2)',
              'rgba(255, 206, 86, 0.2)',
              'rgba(75, 192, 192, 0.2)',
              'rgba(153, 102, 255, 0.2)',
              'rgba(255, 159, 64, 0.2)'
            ].slice(0, num)
  }
}
