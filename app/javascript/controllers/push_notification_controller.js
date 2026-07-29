// 通知許可を取り、ブラウザ側でPush購読を作成する
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
    // ブラウザの通知許可ダイアログが出る。が「許可」した場合だけ、次の処理に進む
    const permission = await Notification.requestPermission()
    if (permission !== "granted") return

    let subscription = await this.service.getSubscription()
    // まだ購読していない場合、新しく購読を作る
  if (!subscription) {
    subscription = await this.service.createSubscription()
  }

  await this.service.saveSubscription(subscription)
  }
}