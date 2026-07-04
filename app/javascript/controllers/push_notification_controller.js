import { Controller } from "@hotwired/stimulus"
import { PushSubscriptionService } from "api/push_subscription"

export default class extends Controller {
  static values = {
    vapidPublicKey: String
  }

  connect() {
    this.service = new PushSubscriptionService(this.vapidPublicKeyValue)
  }

  async subscribe() {
    if (!("serviceWorker" in navigator)) return
    if (!("PushManager" in window)) return
    if (!("Notification" in window)) return

    const permission = await Notification.requestPermission()
    if (permission !== "granted") return

    let subscription = await this.service.getSubscription()

    if (!subscription) {
      subscription = await this.service.createSubscription()
    }

    await this.service.saveSubscription(subscription)
  }
}