import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formHeight", "inputLink"]
  static values = { 
    link: String,
    formId: String
  }
  
  connect() {
    this.updateIframeCode()
    
    // Update if content height changes
    this.observer = new ResizeObserver(() => this.updateIframeCode())
    this.observer.observe(this.formHeightTarget)
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
  
  updateIframeCode() {
    const height = this.formHeightTarget.offsetHeight + 100;
    const iframeCode = `<iframe style="border: none; width: 100%; overflow: hidden; height: ${height}px;" src="${this.linkValue}" scrolling="no"></iframe>`
    this.inputLinkTarget.value = iframeCode
  }
  
  copy() {
    this.inputLinkTarget.select()
    document.execCommand('copy')
    
    // Optional: Show feedback
    const button = event.target
    const originalText = button.textContent
    button.textContent = 'Copied!'
    setTimeout(() => {
      button.textContent = originalText
    }, 2000)
  }
}