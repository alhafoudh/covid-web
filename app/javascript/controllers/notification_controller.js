import {Controller} from 'stimulus';

export default class extends Controller {
  static values = {
    id: String,
    title: String,
    body: String,
    link: String,
  }
  static targets = [
    'title',
    'body',
  ];

  connect() {
    this.titleTarget.innerHTML = this.titleValue;
    this.bodyTarget.innerHTML = this.bodyValue;

    setTimeout(() => {
      this.element.classList.add('md:mr-4')
      this.element.classList.add('md:mx-0')
      this.element.classList.add('mx-2')
      this.element.classList.remove('translate-x-full')
    }, 100)
  }

  click() {
    this.close();

    if (this.linkValue) {
      setTimeout(() => {
        window.location = this.linkValue;
      }, 600)
    }
  }

  close() {
    window.dispatchEvent(new CustomEvent('removeNotification', {detail: {id: this.idValue}}))

    this.element.classList.add('translate-x-full')
    this.element.classList.remove('md:mr-4')
    this.element.classList.remove('md:mx-0')
    this.element.classList.remove('mx-2')

    setTimeout(() => {
      this.element.remove();
    }, 300)
  }
}
