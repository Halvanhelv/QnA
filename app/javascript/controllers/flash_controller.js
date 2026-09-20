import { Controller } from "@hotwired/stimulus"

// Removes a flash message after a delay.
export default class extends Controller {
  static values = { delay: { type: Number, default: 5000 } }

  connect() {
    this.timeout = setTimeout(() => this.element.remove(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
