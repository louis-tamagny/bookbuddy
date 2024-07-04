import { Controller } from '@hotwired/stimulus';

// Se connecte à data-controller="active-link"
export default class extends Controller {
  options = ['home', 'new', 'books', 'series']
  static targets = ['home', 'new', 'books', 'series'];

  connect() {
    const lastUrlWord = window.location.href.split('/').splice(-1)[0];
    this.#setActive(lastUrlWord);
  }

  #setActive(word) {
    if( this.options.includes(word) ){
      this[`${word}Target`].classList.add('active');
    }
  }
}
