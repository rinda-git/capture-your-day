import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text", "rate"]

speak() {
  if(!("speechSynthesis" in window)) {
    alert("このブラウザは音声読み上げに対応していません。")
    return
  }
  
  const text = this.textTarget.textContent.trim()
  const rate = Number(this.rateTarget.value)

  const utterance = new SpeechSynthesisUtterance(text)
  utterance.lang = "en-US"
  utterance.rate = rate
  utterance.pitch = 1

  speechSynthesis.cancel()
  speechSynthesis.speak(utterance)
}

stop() {
  if ("speechSynthesis" in window) {
    speechSynthesis.cancel()
  }
 }
}