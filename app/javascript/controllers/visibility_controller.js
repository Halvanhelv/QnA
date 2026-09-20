import { Controller } from "@hotwired/stimulus"

// Shows an element only to the users allowed to interact with it.
//
// Turbo Stream broadcasts are rendered once and sent to every subscriber, so the
// markup cannot depend on the viewer. Everything user-specific is rendered
// hidden, and this controller reveals it based on the current-user meta tags.
// It is a UX convenience only: the server still authorizes every request.
//
//   data-controller="visibility" data-visibility-rule-value="owner"
//   data-visibility-owner-id-value="<%= record.user_id %>"
//
// Rules: signed_in | owner (author or admin) | not_owner (signed in, not the author)
export default class extends Controller {
  static values = { rule: String, ownerId: Number }

  connect() {
    this.element.hidden = !this.#visible()
  }

  #visible() {
    const userId = this.#meta("current-user-id")
    if (!userId) return false

    const isOwner = Number(userId) === this.ownerIdValue
    const isAdmin = this.#meta("current-user-admin") === "true"

    switch (this.ruleValue) {
      case "owner": return isOwner || isAdmin
      case "not_owner": return !isOwner
      default: return true
    }
  }

  #meta(name) {
    return document.head.querySelector(`meta[name="${name}"]`)?.content
  }
}
