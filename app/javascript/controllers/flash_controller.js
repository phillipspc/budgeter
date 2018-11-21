import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["message", "style"]

  connect() {
    this.styleTargets.forEach((el, i) => {
      el.classList.add(this.styleClass)
    })
  }

  close(event) {
    this.messageTarget.remove()
  }

  get styleClass() {
    const type = this.data.get("type")
    if (type === "notice") {
      return "is-success"
    } else if (type === "alert") {
      return "is-link"
    }
  }
}
