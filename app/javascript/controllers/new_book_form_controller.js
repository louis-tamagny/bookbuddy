import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-book-form"
export default class extends Controller {
  static targets = ['serie', 'illustrator', 'form']

  connect() {
  }

  toggle_illustrator(event) {
    if (['BD', 'Manga', 'Livre illustré'].includes(event.target.value)) {
      this.illustratorTarget.classList.remove("d-none");
    } else {
      this.illustratorTarget.classList.add("d-none");
    }
  }

  toggle_serie(event) {
    if (event.target.value == '') {
      this.serieTarget.classList.remove('d-none')
    } else {
      this.serieTarget.classList.add("d-none");
    }
  }

  toggle_form(event) {
    event.preventDefault()
    if (this.formTarget.classList.contains('d-none')) {
      this.formTarget.classList.remove('d-none')
      event.currentTarget.innerText = 'Annuler'
      // event.currentTarget.classList.remove('mt-5')
    } else {
      this.formTarget.classList.add("d-none");
      event.currentTarget.innerText = "Ajouter manuellement";
      // event.currentTarget.classList.add("mt-5");
    }
  }
}
