import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    console.log("Shop controller connected")
  }

  open(e) {
    console.log("Shop open clicked")
    e.preventDefault()
    this.show()
  }

  show() {
    console.log("Showing modal")
    this.modalTarget.classList.remove("hidden")
    this.prevFocus = document.activeElement
    // move focus into modal
    this.modalTarget.querySelector("button, [href], input, select, textarea")?.focus()
    document.body.classList.add("overflow-hidden")
    this.dispatch("state", { detail: { open: true }})
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
    this.prevFocus?.focus()
    this.dispatch("state", { detail: { open: false }})
  }

  esc(event) {
    if (event.key === "Escape" && !this.modalTarget.classList.contains("hidden")) this.close()
  }
}
