import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["toggle"]
//ページを開いたときに動く
  connect() {
    const savedTheme = localStorage.getItem("theme") || "color"
    this.applyTheme(savedTheme)
    if (this.hasToggleTarget) {
      this.toggleTarget.checked = savedTheme === "color-dark"
    }
  }
  toggle(event) {
    const theme = event.target.checked ? "color-dark" : "color"
    localStorage.setItem("theme", theme)
    this.applyTheme(theme)
  }
  applyTheme(theme) {
    document.documentElement.dataset.theme = theme
  }
}