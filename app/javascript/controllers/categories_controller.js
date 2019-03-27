import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["category", "subCategory"]

  connect() {
    if (this.data.get("updateOnConnect") === 'true') {
      this.updateOptions()
    }
  }

  updateOptions() {
    const controller = this
    const id = this.categoryTarget.value
    const includeBlankSubCategory = this.data.get("includeBlankSubCategory")

    if (id) {
      fetch(`/categories/${id}.json`)
      .then((response) => {
        return response.json()
      })
      .then((json) => {
        let mapped = json.map(el => {
          return `<option value='${el.id}'>${el.name}</option>`
        })
        if (includeBlankSubCategory) {
          mapped.unshift("<option value></option>")
        }
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
