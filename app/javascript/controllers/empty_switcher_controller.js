import {Controller} from "stimulus"

export default class extends Controller {
  static checkedLocalStorageKey = "empty_switcher.checked";

  static values = {defaultChecked: Boolean};
  static targets = ["input"];

  connect() {
    let storedCheckedValue = JSON.parse(localStorage.getItem(this.constructor.checkedLocalStorageKey));
    this.inputTarget.checked = storedCheckedValue === null ? this.defaultCheckedValue : storedCheckedValue;
    this.inputValueChanged();
  }

  clicked() {
    localStorage.setItem(this.constructor.checkedLocalStorageKey, this.inputTarget.checked);
    this.inputValueChanged();
  }

  inputValueChanged() {
    document
      .querySelectorAll(".no-free-capacity")
      .forEach(n => this.inputTarget.checked ? n.classList.add("hidden") : n.classList.remove("hidden"))
  }
}
