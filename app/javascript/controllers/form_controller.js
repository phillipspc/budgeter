import { Controller } from "stimulus"

export default class extends Controller {
  submit(e) {
    // preserve form's remote-ness where applicable
    if (this.element.dataset["remote"]) {
      Rails.fire(this.element, "submit")
    } else {
      // otherwise submit form as normal
      this.element.submit()
    }
  }
}
