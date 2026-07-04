export class PushSubscriptionService {
  constructor(vapidPublicKey){
    this.vapidPublicKey = vapidPublicKey
  }

  async getRegistration() {
    await navigator.serviceWorker.register("/service-worker.js")
    return navigator.serviceWorker.ready
  }

  async getSubscription() {
    const registration = await this.getRegistration()
    return registration.pushManager.getSubscription()
  }

  async createSubscription() {
    const registration = await this.getRegistration()

    return registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: Uint8Array.fromBase64(this.vapidPublicKey,
        alphabet: "base64url"
      })
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

  csrfHeaders() {
    return {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      
    }
  }
}