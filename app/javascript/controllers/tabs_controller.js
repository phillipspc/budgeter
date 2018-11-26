import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button", "content"]

  connect() {
    let active = this.buttonTargets.find(el => {return el.classList.contains("is-active")})
    console.log(active)
  }

  update(e) {
    this.updateTab(e.target)
  }

  updateTab(tab) {
    this.buttonTargets.forEach(el => {
      if (el === tab) {
        el.classList.add("is-active")
      } else {
        el.classList.remove("is-active")
      }
    })

    this.contentTargets.forEach(el => {
      if (el === tab) {
        el.classList.add("is-active")
      } else {
        el.classList.remove("is-active")
      }
    })
  }
}
