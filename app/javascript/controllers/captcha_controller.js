import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let time = 15;
    const timerElement = document.getElementById('time');
    const form = document.getElementById('captcha-form');

    const countdown = setInterval(() => {
      time--;
      timerElement.textContent = time;

      if (time <= 0) {
        form.requestSubmit();
      }
    }, 1000);
  }
}
