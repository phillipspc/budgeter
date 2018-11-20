import { Controller } from "stimulus"

export default class extends Controller {
  close(e) {
    e.preventDefault()
    this.element.classList.remove("is-active")
  }
}
