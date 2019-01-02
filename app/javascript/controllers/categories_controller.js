import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["category", "subCategory"]

  connect() {
    this.updateOptions()
  }

  updateOptions() {
    const controller = this
    const id = this.categoryTarget.value

    if (id) {
      fetch(`/categories/${id}.json`)
      .then((response) => {
        return response.json()
      })
      .then((json) => {
        let mapped = json.map(el => {
          return `<option value='${el.id}'>${el.name}</option>`
        })
        controller.subCategoryTarget.innerHTML = mapped.join('')
        controller.subCategoryTarget.disabled = false
      })
    } else {
      controller.subCategoryTarget.innerHTML = "<option></option>"
      controller.subCategoryTarget.value = null
      controller.subCategoryTarget.disabled = true
    }
  }
}
