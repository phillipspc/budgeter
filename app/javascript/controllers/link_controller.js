import { Controller } from "stimulus"

export default class extends Controller {
  confirm(e) {
    const message = this.data.get("confirmMessage")
    if (!confirm(message)) {
      e.stopPropagation()
      e.preventDefault()
    }
  }
}
