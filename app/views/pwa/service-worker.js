// Add a service worker for processing Web Push notifications:
//
// self.addEventListener("push", async (event) => {
//   const { title, options } = await event.data.json()
//   event.waitUntil(self.registration.showNotification(title, options))
// })

self.addEventListener("notificationclick", function(event) {
  event.notification.close()

  const path = event.notification.data?.path || "/"
  event.waitUntil(
    clients.matchAll({
      type: "window",
    includeUncontrolled: true 
  }).then((clientList) => {
    const Url = new URL(path, self.location.origin).href
    const existingClient = clientList.find(
      (client) => client.url === targetUrl
    )

    if (existingClient && "focus" in existingClient) {
      return existingClient.focus()
    }

    if (clients.openWindow) {
      return clients.openWindow(path)
    }
    })
  )
})

// Push通知を受け取り、ブラウザ通知として表示する
self.addEventListener("push", (event) => {
  const data = event.data ? event.data.json() : { title: "通知", options: {} } 

  event.waitUntil(
    self.registration.showNotification(data.title, data.options || {})
  )
})