
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["avatar", "notification"]

  toggleAvatarTargets() {
    this.avatarTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  }

  toggleNotificationTargets() {
    this.notificationTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  }

  hideAvatarTargets(event) {
    const avatarMenu = document.getElementById("avatar-menu")
    // Don't hide the dropdown menu if that is clicked
    if (event && event.target === avatarMenu || this.avatarTargets.includes(event.target) || this.avatarTargets.every(t => t.contains(event.target))) {
      return;
    }
    this.avatarTargets.forEach((el) => {
      el.hidden = "hidden"
    });
  }

  hideNotificationTargets(event) {
    const notificationMenu = document.getElementById("notifications-menu")
    // Don't hide the dropdown menu if that is clicked
    if (event && event.target === notificationMenu || this.notificationTargets.includes(event.target) || this.notificationTargets.every(t => t.contains(event.target))) {
      return;
    }
    this.notificationTargets.forEach((el) => {
      el.hidden = "hidden"
    });
  }
}