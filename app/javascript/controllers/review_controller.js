import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    this.outputTarget.textContent = 'Hello, Stimulus!'
  }
}
