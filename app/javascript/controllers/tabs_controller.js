import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button", "content"]

  connect() {
    let active = this.buttonTargets.find(el => {return el.classList.contains("is-active")})
    if (active) {
      updateTab(active)
    }
  }

  update(e) {
    this.updateTab(e.target)
  }

  updateTab(tab) {
    this.buttonTargets.forEach(el => {
      if (el === tab) {
        el.closest("li").classList.add("is-active")
      } else {
        el.closest("li").classList.remove("is-active")
      }
    })

    this.contentTargets.forEach(el => {
      if (el.dataset["content"] === tab.dataset["tabFor"]) {
        el.classList.remove("is-hidden")
      } else {
        el.classList.add("is-hidden")
      }
    })
  }
}
