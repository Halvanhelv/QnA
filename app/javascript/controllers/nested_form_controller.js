import { Controller } from "@hotwired/stimulus"

// Adds and removes nested attributes fields (replaces cocoon).
//
//   <div data-controller="nested-form" data-nested-form-wrapper-selector-value=".nested-fields">
//     <template data-nested-form-target="template">...NEW_RECORD...</template>
//     <div data-nested-form-target="container"></div>
//     <button data-action="nested-form#add">Add</button>
//   </div>
export default class extends Controller {
  static targets = ["template", "container"]
  static values = { wrapperSelector: { type: String, default: ".nested-fields" } }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now().toString())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest(this.wrapperSelectorValue)
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.hidden = true
      wrapper.querySelector("input[name*='_destroy']").value = "1"
    }
  }
}
