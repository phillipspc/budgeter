import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["category", "subCategory"]

  updateOptions() {
    const controller = this
    const id = this.categoryTarget.value

    if (id) {
      fetch(`/categories/${id}`)
      .then((response) => {
        return response.json()
      })
      .then((json) => {
        let mapped = json.map(el => {
          return `<option value='${el.id}'>${el.name}</option>`
        })
        mapped.unshift("<option></option>")
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
