import {Controller} from "stimulus"
import {formatDistanceToNow, parseISO, differenceInMinutes} from "date-fns"
import * as dateFnsLocales from "date-fns/locale"

export default class extends Controller {
  static values = {
    lastUpdated: String,
    updateInterval: Number,
    tickInterval: Number,
  };
  static targets = [
    "output",
    "oldIndicator"
  ];
  static classes = [
    "fresh",
    "old",
  ];

  connect() {
    this.lastUpdated = parseISO(this.lastUpdatedValue);
    this.timer = setInterval(this.tick.bind(this), this.tickIntervalValue);
    this.locale = dateFnsLocales[document.documentElement.lang];

    this.tick();
  }

  disconnect() {
    clearInterval(this.timer);
  }

  isOld() {
    return differenceInMinutes(new Date(), this.lastUpdated) > this.updateIntervalValue;
  }

  tick() {
    if (this.isOld()) {
      this.oldIndicatorTarget.classList.add(this.oldClass);
      this.oldIndicatorTarget.classList.remove(this.freshClass);
    } else {
      this.oldIndicatorTarget.classList.add(this.freshClass);
      this.oldIndicatorTarget.classList.remove(this.oldClass);
    }
    this.outputTarget.innerHTML = formatDistanceToNow(this.lastUpdated, {
      addSuffix: true,
      locale: this.locale,
    });
  }
}
