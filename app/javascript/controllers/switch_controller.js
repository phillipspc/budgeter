import { Controller } from "stimulus"

export default class extends Controller {
  patch () {
    Rails.ajax({
      url: this.data.get("url"),
      type: "PATCH",
      data: this.data.get("patch-data")
    });
  }
}
