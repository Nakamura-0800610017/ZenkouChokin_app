import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "submit"]

  connect() {
    this.toggle()
  }

  toggle() {
    const checked = this.checkboxTarget.checked
    this.submitTarget.disabled = !checked

    this.submitTarget.classList.toggle("btn-primary", checked)
    this.submitTarget.classList.toggle("btn-secondary", !checked)
  }
}