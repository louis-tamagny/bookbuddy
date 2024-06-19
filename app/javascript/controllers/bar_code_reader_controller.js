import { Controller } from "@hotwired/stimulus"
import "@zxing/library";


// Connects to data-controller="bar-code-reader"
export default class extends Controller {
  static targets = ['sourceSelect', 'sourceSelectPanel', "start", "reset", "videoWrapper", "tempBook", 'alert', 'search']

  connect() {
    this.codeReader = new ZXing.BrowserMultiFormatReader();
    this.codeReader
      .getVideoInputDevices()
      .then((videoInputDevices) => {
        this.selectedDeviceId = videoInputDevices[0].deviceId;
        if (videoInputDevices.length > 1) {
          videoInputDevices.forEach((element) => {
            const sourceOption = document.createElement("option");
            sourceOption.text = element.label;
            sourceOption.value = element.deviceId;
            this.sourceSelectTarget.appendChild(sourceOption);
          });

          this.sourceSelectTarget.onchange = () => {
            this.selectedDeviceId = this.sourceSelectTarget.value;
          };

          const sourceSelectPanel =
            this.sourceSelectPanelTarget;
          this.sourceSelectPanelTarget.style.display = "block";
        }
      })
      .catch((err) => {
        console.error(err);
      });
  }
  start(){
    if (this.codeReader) {
      this.videoWrapperTarget.classList.remove("d-none");
      this.codeReader.decodeFromVideoDevice(
        this.selectedDeviceId,
        "barcode-video",
        (result, err) => {
          if (result) {
            this.reset()
            this.#getBookDetails(result.text)
          }
          if (err && !(err instanceof ZXing.NotFoundException)) {
            console.error(err);

          }
        }
      );
      this.startTarget.classList.add('d-none');
      this.resetTarget.classList.remove("d-none");
    }
  }

  reset(){
    if (this.codeReader) {
      this.codeReader.reset();
      this.startTarget.classList.remove("d-none");
      this.resetTarget.classList.add("d-none");
      this.videoWrapperTarget.classList.add("d-none");
    }
  }

  #getBookDetails(isbn){
    const url = `https://openlibrary.org/isbn/${isbn}.json`;
    fetch(url)
      .then(res => res.json())
      .then(data => {
        if (data.error) {
          console.error("Book not found")
          this.reset()
        }
        if (!data.by_statement) {
          fetch(`https://openlibrary.org${data.authors[0].key}.json`)
            .then((response) => response.json())
            .then((authorData) => {
              data.author = authorData.name;
              const bookData = this.#deserializeISBNFromOpenLibrary(data, isbn)
              this.#getBookCard(bookData)
          });
        } else {
          const bookData = this.#deserializeISBNFromOpenLibrary(data, isbn);
          this.#getBookCard(bookData);
        }


      })
      .catch(error => {
        console.error(error.message)
        window.alert(`Erreur: ISBN N°${isbn} n'a pas été trouvé`)
        this.reset()
    })
  }

  #deserializeISBNFromOpenLibrary(apiBookData, isbn){
    const bookData = {
      title: apiBookData.title,
      author: apiBookData.author || apiBookData.by_statement.slice(0, -1),
      isbn: isbn,
    };
    if (apiBookData.genres) bookData.genres = apiBookData.genres.map(genre => genre.slice(0, -1))
    if (apiBookData.publishers) bookData.edition = apiBookData.publishers[0]
    if (apiBookData.publish_date) bookData.release = apiBookData.publish_date
    if (apiBookData.series) bookData.serieNames = apiBookData.series
    if (apiBookData.covers) bookData.cover_url = `https://covers.openlibrary.org/b/id/${apiBookData.covers[0]}-M.jpg`;

    return bookData
  }

  #getBookCard(bookData) {
    const urlParams = new URLSearchParams(bookData)
    const url = `/books/new?${urlParams}`
    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then((data) => {
        if (data != '') {
          this.tempBookTarget.insertAdjacentHTML('beforeend', data)
          this.tempBookTarget.classList.remove('d-none')
        }
        return data;
    })

  }

  fetchDbBooks(event) {
    event.preventDefault()
    const url = `/books?query=${this.searchTarget.value}&my=false`
    fetch(url, { headers: { Accept: "text/plain" } })
      .then((response) => response.text())
      .then((data) => {
        if (data === ""){
          this.fetchApiBooks()
        } else {
          this.tempBookTarget.classList.remove("d-none");
          this.tempBookTarget.innerHTML = data;
        }

      });
  }

  fetchApiBooks(){
    const fields = "fields=title,first_sentence,author_name,cover_i,first_publish_year,publisher,isbn"
    const limit = "limit=5"
    const url = `https://openlibrary.org/search.json?q=${this.searchTarget.value.replace(/\s/g, '+')}&lang=fr&${limit}&${fields}`;
    fetch(url, { headers: { Accept: "application/json" } })
      .then((response) => response.json())
      .then((data) => {
        if (data === "") {
        } else {
          this.tempBookTarget.innerHTML = "";
          const booksData = data.docs
            .filter((doc) => doc.cover_i)
            .map((doc) => this.#deserializeFromOpenLibrary(doc));
          console.log(booksData);
          booksData.forEach((bookData) => this.#getBookCard(bookData))
        }
      });
  }

  #deserializeFromOpenLibrary(doc) {
    const bookData = { title: doc.title,
      cover_url: doc.cover_i ? `https://covers.openlibrary.org/b/id/${doc.cover_i}-M.jpg`: undefined
    }

    if (bookData.title) {
      if (doc.first_sentence) bookData.description = doc.first_sentence[0]
      if (doc.author_name) bookData.author = doc.author_name[0];
      if (doc.first_publish_year) bookData.release = doc.first_publish_year
      if (doc.publisher) bookData.edition = doc.publisher[0]
      if (doc.isbn) bookData.isbn = doc.isbn[1] || doc.isbn[0]
    }

    return bookData
  }
}
