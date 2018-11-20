import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]

  toggle() {
    this.contentTarget.classList.toggle("collapsed")

    if (this.contentTarget.classList.contains("collapsed")) {
      this.iconTarget.innerHTML = this.upArrowIcon
    } else {
      this.iconTarget.innerHTML = this.downArrowIcon
    }
  }

  get upArrowIcon() {
    return "<i class='fas fa-angle-up'></i>"
  }

  get downArrowIcon() {
    return "<i class='fas fa-angle-down'></i>"
  }
}
