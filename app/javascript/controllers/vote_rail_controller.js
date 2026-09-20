import { Controller } from "@hotwired/stimulus"

// Marks the current user's vote on a vote rail.
//
// Broadcast HTML is the same for everyone, so a person's own votes come from a JSON map in the page
// (<script id="my-votes">, e.g. {"Question:1": 1, "Answer:3": -1}). After voting, the server replaces
// the rail with an explicit score and refreshes that map.
export default class extends Controller {
  static targets = ["up", "down"]
  static values = { key: String, score: { type: Number, default: 0 }, explicit: { type: Boolean, default: false } }

  connect() {
    if (!this.explicitValue) this.scoreValue = this.#stored[this.keyValue] || 0
    this.#render()
  }

  scoreValueChanged() {
    this.#render()
  }

  #render() {
    if (!this.hasUpTarget) return

    this.upTarget.setAttribute("aria-pressed", String(this.scoreValue > 0))
    this.downTarget.setAttribute("aria-pressed", String(this.scoreValue < 0))
  }

  get #stored() {
    try {
      return JSON.parse(document.getElementById("my-votes")?.textContent || "{}")
    } catch {
      return {}
    }
  }
}
