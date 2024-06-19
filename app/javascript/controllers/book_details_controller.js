import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="book-details"
export default class extends Controller {
  static targets = ['modal'];

  connect() {
    console.log('icic');
  }

  showModal() {
    this.modalTarget.style.display = 'flex';
  }

  hideModal() {
    this.modalTarget.style.display = 'none';
  }
}
