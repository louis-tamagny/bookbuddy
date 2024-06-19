import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="manga-api-connect"
export default class extends Controller {
  connectionCreds = {
    grant_type: 'password',
    username: 'hidroyd',
    password: '#a*7NEA^j3Q^u9',
    client_id: 'personal-client-e4c4220a-f785-4121-a30c-61aa61fc53a4-4283a005',
    client_secret: 'UE7kWQDMglcdZyIeBYR2ppz0vnDkIp5T',
  };

  refreshCreds = {
    grant_type: 'refresh_token',
    refresh_token: '',
    client_id: 'personal-client-e4c4220a-f785-4121-a30c-61aa61fc53a4-4283a005',
    client_secret: 'UE7kWQDMglcdZyIeBYR2ppz0vnDkIp5T',
  };

  url =
    'https://auth.mangadex.org/realms/mangadex/protocol/openid-connect/token';

  connect() {
    this.#get_conection_token(() => {
      this.refreshCreds.refresh_token = localStorage.getItem('refresh_token');
    });

    setInterval(() => {
      this.#refresh_connection_token();
    }, localStorage.getItem('expires_in'));
  }

  #get_conection_token(_callBack) {
    this.#call_api(this.url, 'POST', this.connectionCreds);
    _callBack();
  }

  #refresh_connection_token() {
    this.#call_api(this.url, 'POST', this.refreshCreds);
  }

  #call_api(url, method, body) {
    const formBody = Object.keys(body)
      .map(
        (key) => encodeURIComponent(key) + '=' + encodeURIComponent(body[key])
      )
      .join('&');

    fetch(url, {
      method: method,
      headers: {
        'User-Agent': navigator.userAgent,
        'Content-type': 'application/x-www-form-urlencoded',
      },
      body: formBody,
    }).then((response) =>
      response.json().then((data) => {
        localStorage.clear();
        for (const key in data) {
          localStorage.setItem(key, data[key]);
        }
      })
    );
  }
}
