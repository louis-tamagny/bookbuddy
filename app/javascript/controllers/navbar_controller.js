import { Controller } from '@hotwired/stimulus';

// Se connecte à data-controller="active-link"
export default class extends Controller {
  static targets = ['home', 'new', 'books', 'series'];

  connect() {
    const lastUrlWord = window.location.href.split('/').splice(-1);
    this.#setActive(lastUrlWord);
  }

  #setActive(word) {
    this[`${word}Target`].classList.add('active');
  }
}
