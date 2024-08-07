import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="index-search"
export default class extends Controller {
  static targets = ['input', 'list', 'owned', 'favorite', 'genresBox'];

  connect() {}

  genres = [];

  updateGenres(event) {
    if (event.target.checked) {
      this.genres.push(event.target.value);
    } else {
      this.genres.splice(this.genres.indexOf(event.target.value), 1);
    }
    this.search();
  }

  showGenres(event) {
    if (event.target.checked) {
      this.genresBoxTarget.classList.remove('d-none');
    } else {
      this.genresBoxTarget.classList.add('d-none');
    }
  }

  toggleFavoriteSwitch() {
    this.favoriteTarget.checked = false
    this.favoriteTarget.parentElement.classList.toggle('d-none');
  }


  search() {
    const url = `/books?query=${this.inputTarget.value}&owned=${this.ownedTarget.checked}&genres=${this.genres.join('+')}&favorite=${this.favoriteTarget.checked}`;
    fetch(url, { headers: { Accept: 'text/plain' } })
      .then((response) => response.text())
      .then((data) => {
        this.listTarget.innerHTML = data;
      });
  }
}
