import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text", "rate", "playButton", "stopButton"]

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

  utterance.onend = () => {
    this.showPlayButton()
  }

  utterance.onerror = () => {
    this.showPlayButton()
  }

  speechSynthesis.cancel()
  speechSynthesis.speak(utterance)
  this.showStopButton()
 }

stop() {
  if ("speechSynthesis" in window) {
    speechSynthesis.cancel()
  }
  this.showPlayButton()
 }

 disconnect() {
  if("speechSynthesis" in window)
    speechSynthesis.cancel()
 }

showStopButton() {
  this.playButtonTarget.classList.add("hidden")
  this.stopButtonTarget.classList.remove("hidden")
 }

showPlayButton() {
  this.stopButtonTarget.classList.add("hidden")
  this.playButtonTarget.classList.remove("hidden")
 }
}