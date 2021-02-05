import {Controller} from "stimulus"

export default class extends Controller {
  static targets = ["trigger"];

  static values = {
    triggerOffset: Number,
  };

  static classes = [
    "scrolled",
    "ontop",
  ];

  connect() {
    this.onClick = this.onClick.bind(this);
    this.triggerTarget.addEventListener('click', this.onClick);

    this.onScroll = this.onScroll.bind(this);
    window.addEventListener('scroll', this.onScroll);

    this.onScroll();
  }

  disconnect() {
    this.triggerTarget.removeEventListener('click', this.onClick);
    window.removeEventListener('scroll', this.onScroll);
  }

  onClick(event) {
    event.preventDefault();

    window.scrollTo(0, 0);
  }

  onScroll() {
    const showTriggerButton = document.body.scrollTop > this.triggerOffsetValue || document.documentElement.scrollTop > this.triggerOffsetValue
    this.triggerTarget.classList.toggle(this.scrolledClass, showTriggerButton);
    this.triggerTarget.classList.toggle(this.ontopClass, !showTriggerButton);
  }
}

