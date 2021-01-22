import {Controller} from "stimulus"

export default class extends Controller {
  static configurationLocalStorageKey = "cookies";
  static targets = ["container", "configPanel", "analyticsCheckbox", "marketingCheckbox", "acceptAllButton", "saveConfigurationButton"];

  connect() {
    const configuration = JSON.parse(localStorage.getItem(this.constructor.configurationLocalStorageKey));

    if (configuration) {
      this.initializeScripts(configuration);
    } else {
      setTimeout(() => {
        this.toggle();
      }, 1000);
    }
  }

  acceptAll() {
    const configuration = {analytic: true, marketing: true}
    this.saveConfiguration(configuration)
  }

  toggleConfigurationForm() {
    this.configPanelTarget.classList.toggle('hidden')
    this.acceptAllButtonTarget.classList.toggle('hidden')
    this.saveConfigurationButtonTarget.classList.toggle('hidden')
  }

  saveConfigurationForm() {
    const analytic = this.analyticsCheckboxTarget.checked;
    const marketing = this.marketingCheckboxTarget.checked;
    const configuration = {analytic, marketing};
    this.saveConfiguration(configuration);
  }

  saveConfiguration(configuration) {
    localStorage.setItem(this.constructor.configurationLocalStorageKey, JSON.stringify(configuration));
    this.initializeScripts(configuration);
    this.toggle();
  }

  initializeScripts(configuration) {
    console.log('init with configuration', configuration);
    if (configuration.analytic) {
      console.log('trigger analytic consent')
      window.dataLayer.push({event: 'consentAnalyticCookies'})
    }
    if (configuration.marketing) {
      console.log('trigger marketing consent')
      window.dataLayer.push({event: 'consentMarketingCookies'})
    }
  }

  toggle() {
    this.containerTarget.classList.toggle('translate-y-1/2')
    this.containerTarget.classList.toggle('opacity-100')
  }
}
