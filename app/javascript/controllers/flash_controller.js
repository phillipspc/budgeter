import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['progressBar']

  connect() {
    this.progressBarTarget.style.cssText = `-webkit-animation-duration: ${this.cssDuration}s;`
    this.progressBarTarget.style.cssText = `animation-duration: ${this.cssDuration}s;`

    this.isOpen = true
    const controller = this

    // automatically dismiss notification after set duration
    setTimeout(function() {
      // check that the notification hasn't already been dismissed
      if (controller.isOpen) {
        controller.close()
      }
    }, controller.duration)
  }

  close(event) {
    this.element.remove()
  }

  get duration() {
    return 4000
  }

  get cssDuration() {
    return (this.duration / 1000)
  }
}
