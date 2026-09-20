import { Controller } from "@hotwired/stimulus"

// Ctrl/Cmd + Enter submits the form (works from the Lexxy editor and plain fields).
//
//   form data-controller="submit-shortcut" data-action="keydown->submit-shortcut#submit"
export default class extends Controller {
  submit(event) {
    if (event.key !== "Enter" || !(event.metaKey || event.ctrlKey)) return

    event.preventDefault()
    this.element.requestSubmit()
  }
}
