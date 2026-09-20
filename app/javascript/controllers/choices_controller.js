import { Controller } from "@hotwired/stimulus"
import Choices from "choices.js"

// Choices.js options that can be set through data attributes
const OPTION_NAMES = [
  "searchEnabled", "searchChoices", "searchFloor", "searchResultLimit", "searchPlaceholderValue",
  "placeholder", "placeholderValue", "noResultsText", "noChoicesText", "itemSelectText",
  "removeItemButton", "maxItemCount", "position", "shouldSort"
]

// Styled select powered by Choices.js (same approach as the Gnosis app).
//
//   <div data-controller="choices">
//     <select data-choices-target="select" data-search-enabled="false">...</select>
//   </div>
//
// Choices.js options are read from data attributes on the controller element
// (data-search-enabled, data-placeholder-value, data-no-results-text, ...).
export default class extends Controller {
  static targets = ["select"]

  connect() {
    this.reload = this.reload.bind(this)
    this.teardown = this.teardown.bind(this)
    this.#setup()

    document.addEventListener("turbo:morph", this.reload)
    // Turbo snapshots the page for its cache: hand it the plain <select>, not Choices' markup
    document.addEventListener("turbo:before-cache", this.teardown)
  }

  disconnect() {
    document.removeEventListener("turbo:morph", this.reload)
    document.removeEventListener("turbo:before-cache", this.teardown)
    this.teardown()
  }

  reload() {
    if (!this.choices) return

    this.teardown()
    this.#setup()
  }

  enable() {
    this.choices?.enable()
  }

  teardown() {
    this.choices?.destroy()
    this.choices = null
  }

  #setup() {
    this.choices = new Choices(this.selectTarget, {
      searchPlaceholderValue: "Search",
      searchFloor: 1,
      searchResultLimit: 10,
      fuseOptions: { threshold: 0.2 },
      itemSelectText: "",
      allowHTML: false,
      ...this.#options()
    })
  }

  #options() {
    return OPTION_NAMES.reduce((options, name) => {
      const value = this.selectTarget.dataset[name] ?? this.element.dataset[name]

      if (value !== undefined) {
        options[name] = value === "true" || value === "false" ? JSON.parse(value) : value
      } else if (name === "shouldSort") {
        options[name] = false // keep the order given by the server
      }

      return options
    }, {})
  }
}
