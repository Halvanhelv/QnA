import { Controller } from "@hotwired/stimulus"

// Clears the form after a successful Turbo submission.
//
//   form data-controller="reset-form" data-action="turbo:submit-end->reset-form#reset"
export default class extends Controller {
  reset(event) {
    if (event.detail.success) this.element.reset()
  }
}
