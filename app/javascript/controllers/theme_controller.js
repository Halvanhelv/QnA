import { Controller } from "@hotwired/stimulus"

// Light/dark switch. The initial value is set by an inline script in the layout (no flash);
// this controller stores the explicit choice and follows the OS while nothing is stored.
export default class extends Controller {
  connect() {
    this.media = window.matchMedia("(prefers-color-scheme: dark)")
    this.follow = (event) => {
      if (!this.#stored) this.#apply(event.matches ? "dark" : "light")
    }
    this.media.addEventListener("change", this.follow)
  }

  disconnect() {
    this.media.removeEventListener("change", this.follow)
  }

  toggle() {
    const next = document.documentElement.dataset.theme === "dark" ? "light" : "dark"
    try { localStorage.setItem("theme", next) } catch { /* private mode: keep the choice for this page only */ }
    this.#apply(next)
  }

  #apply(theme) {
    document.documentElement.dataset.theme = theme
  }

  get #stored() {
    try { return localStorage.getItem("theme") } catch { return null }
  }
}
