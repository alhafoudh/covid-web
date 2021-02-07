import {Controller} from "stimulus"

export default class extends Controller {
  static values = {
    enabled: Boolean,
  };

  static targets = [
    'enable',
    'disable',
  ];

  static classes = [
    'enabled',
    'disabled',
  ];

  connect() {
    this.enabledValue = false;
  }

  click() {
    this.enabledValue = !this.enabledValue;
    console.log(this.enabledValue);
  }

  enabledValueChanged() {
    this.enableTarget.classList.toggle(this.enabledClass, !this.enabledValue);
    this.enableTarget.classList.toggle(this.disabledClass, this.enabledValue);

    this.disableTarget.classList.toggle(this.enabledClass, this.enabledValue);
    this.disableTarget.classList.toggle(this.disabledClass, !this.enabledValue);
  }
}
