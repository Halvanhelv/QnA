import { Controller } from "@hotwired/stimulus"

// Draws the eye to something that has just appeared through a Turbo Stream: a brief highlight,
// and a scroll into view when the current user is the one who created it.
// Content that was already on the page when it loaded (created a while ago) is left alone.
export default class extends Controller {
  static values = { at: String, authorId: Number }

  connect() {
    if (Date.now() - new Date(this.atValue).getTime() > 4000) return

    this.element.classList.add("arrival")
    if (this.#currentUserId === this.authorIdValue) {
      this.element.scrollIntoView({ behavior: this.#reducedMotion ? "auto" : "smooth", block: "center" })
    }
  }

  get #currentUserId() {
    return Number(document.head.querySelector('meta[name="current-user-id"]')?.content)
  }

  get #reducedMotion() {
    return window.matchMedia("(prefers-reduced-motion: reduce)").matches
  }
}
