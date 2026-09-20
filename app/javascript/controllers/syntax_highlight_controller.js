import { Controller } from "@hotwired/stimulus"
import { highlightCode } from "lexxy"

// Highlights code blocks inside rendered Action Text content.
// Runs on connect, so it also covers content that arrives through Turbo Streams.
export default class extends Controller {
  connect() {
    highlightCode()
  }
}
