import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["checkbox", "dateField", "dateInput"]
  connect() {
    if (this.checkboxTarget.checked) {
      this.dateFieldTarget.classList.add("is-hidden")
      this.dateInputTarget.value = ""
    }
    this.today = new Date()
  }

  update(e) {
    this.toggleDateField(e.target)
  }

  toggleDateField(checkbox) {
    if (checkbox.checked) {
      this.dateFieldTarget.classList.add("is-hidden")
      this.dateInputTarget.value = ""
    } else {
      this.dateFieldTarget.classList.remove("is-hidden")
      let month = this.today.getMonth() + 1
      if (month < 10) {
        month = `0${month}`
      }

      let date = this.today.getDate()
      if (date < 10) {
        date = `0${date}`
      }

      this.dateInputTarget.value = `${this.today.getFullYear()}-${month}-${date}`
    }
  }
}
