import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["type", "point"]

  connect() {
    this.update()
  }

  update() {
    const type = this.typeTarget.value
    const pointSelect = this.pointTarget

    pointSelect.innerHTML = ""
    
    if (type === "zenkou") {

      for (let i = 1; i <= 10; i++) {
        const option = new Option(i, i)
        pointSelect.add(option)
      }

      pointSelect.value = (currentValue >= 1 && currentValue <= 10) ? currentValue : 1
    } else if (type === "akugyou") {

      for (let i = -1; i >= -10; i--) {
        const option = new Option(i, i)
        pointSelect.add(option)
      }

      pointSelect.value = (currentValue <= -1 && currentValue >= -10) ? currentValue : -1
    }
  }
}