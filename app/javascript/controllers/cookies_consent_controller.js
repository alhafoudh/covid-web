import {Controller} from "stimulus"

export default class extends Controller {
  static configurationLocalStorageKey = "cookies";
  static targets = ["container", "info", "configPanel", "analyticsCheckbox", "acceptAllButton", "saveConfigurationButton"];

  connect() {
    const configuration = JSON.parse(localStorage.getItem(this.constructor.configurationLocalStorageKey));

    if (configuration) {
      this.initializeScripts(configuration);
    } else {
      setTimeout(() => {
        this.toggle(true);
      }, 1000);
    }
  }

  acceptAll() {
    const configuration = {}
    this.saveConfiguration(configuration)
  }

  toggleConfigurationForm() {
    this.configPanelTarget.classList.toggle('hidden')
    this.infoTarget.classList.toggle('hidden')
    this.acceptAllButtonTarget.classList.toggle('hidden')
    this.saveConfigurationButtonTarget.classList.toggle('hidden')
  }

  saveConfigurationForm() {
    const analytic = this.analyticsCheckboxTarget.checked;
    const configuration = {analytic};
    this.saveConfiguration(configuration);
  }

  saveConfiguration(configuration) {
    localStorage.setItem(this.constructor.configurationLocalStorageKey, JSON.stringify(configuration));
    this.initializeScripts(configuration);
    this.toggle(false);
  }

  initializeScripts(configuration) {
    if (configuration.analytic && !document.documentElement.hasAttribute("data-analytics-installed")) {
      window.dataLayer.push({event: 'consentAnalyticCookies'})
      document.documentElement.setAttribute("data-analytics-installed", "");
    }
  }

  toggle(show) {
    this.containerTarget.classList.toggle('translate-y-1/2', !show)
    this.containerTarget.classList.toggle('opacity-100', show)
  }
}
