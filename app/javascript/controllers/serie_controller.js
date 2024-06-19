import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="series-tabs"
export default class extends Controller {
  static targets = ['progressValue', 'progressBar', 'userProgress'];

  connect() {
    const userProgressionArray = this.userProgressTarget.innerHTML.split('');
    const userPercentage =
      (parseFloat(userProgressionArray[1], 10) /
        parseFloat(userProgressionArray[5], 10)) *
      100;

    this.progressValueTarget.style.width = `${userPercentage}%`;
  }

  refresh() {
    location.reload();
  }
}
