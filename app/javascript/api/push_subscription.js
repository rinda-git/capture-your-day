export class PushSubscriptionService {
  // 購読作成
  // 購読情報をRailsへ送信
  constructor(vapidPublicKey){
    this.vapidPublicKey = vapidPublicKey
  }
  // Service Worker を登録して、準備完了した登録情報を返す
  async getRegistration() {
    await navigator.serviceWorker.register("/service-worker")
    return navigator.serviceWorker.ready
  }
  // 既に通知購読済みか確認する
  async getSubscription() {
    const registration = await this.getRegistration()
    return registration.pushManager.getSubscription()
  }
  // 未購読なら pushManager.subscribe で購読情報を作る
  async createSubscription() {
    const registration = await this.getRegistration()

    return registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: Uint8Array.fromBase64(this.vapidPublicKey, { alphabet: "base64url"})
    })
  }

  async saveSubscription(subscription) {
    const { endpoint, keys } = subscription.toJSON()
    if(!endpoint || !keys?.p256dh || !keys?.auth) return false
    const response = await fetch("/web_push_subscriptions", {
      method: "POST",
      headers: this.csrfHeaders(),
      body: JSON.stringify({
        endpoint,
        p256dh: keys.p256dh,
        auth: keys.auth
      })
    })
    return response.ok
  }
  // Rails に POST するための CSRF ヘッダーを作る
  csrfHeaders() {
    return {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      
    }
  }
}