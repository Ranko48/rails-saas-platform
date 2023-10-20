
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hideable"]

  toggleTargets() {
    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  }

  hideTargets(event) {
    const avatarMenu = document.getElementById("avatar-menu")
    if (event && event.target === avatarMenu || this.hideableTargets.includes(event.target) || this.hideableTargets.every(t => t.contains(event.target))) {
      console.log('return')
      return;
    }
    this.hideableTargets.forEach((el) => {
      el.hidden = "hidden"
    });
  }
}