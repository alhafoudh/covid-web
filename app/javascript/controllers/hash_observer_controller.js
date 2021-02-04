import {Controller} from "stimulus"

export default class extends Controller {
  static values = {
    hash: String,
  };

  static targets = [
    'element'
  ];

  static classes = [
    'active'
  ];

  connect() {
    this.hashDidChange = this.hashDidChange.bind(this);
    window.addEventListener('hashchange', this.hashDidChange, false);

    this.hashDidChange();
  }

  disconnect() {
    window.removeEventListener('hashchange', this.hashDidChange)
  }

  hashDidChange() {
    this.elementTarget.classList.toggle(this.activeClass, location.hash === this.hashValue);
  }
}
