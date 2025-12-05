import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formHeight", "inputLink"]
  static values = { 
    link: String,
    fieldCount: Number
  }
  
  connect() {
    this.updateIframeCode()
    
    this.observer = new ResizeObserver(() => this.updateIframeCode())
    this.observer.observe(this.formHeightTarget)
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
  
  updateIframeCode() {
    // const height = this.formHeightTarget.offsetHeight + (this.fieldCountValue + 1) * 22 + 62; // with notification
    const height = this.formHeightTarget.offsetHeight;

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