import {Controller} from 'stimulus';
import firebase from 'firebase/app';

export default class extends Controller {
  static allowedNotificationsLocalStorageKey = "region_notifications.allowed_notifications";

  static targets = [
    'enableButton',
    'disableButton',
  ];

  static classes = [
    'enabled',
    'disabled',
    'allowDisabled',
    'hide',
  ];

  static values = {
    serviceWorkerUrl: String,
    subscriptionsUrl: String,
  };

  connect() {
    // Bail early when notifications are not supported
    // Bailing here omits any button initializations or token loading so
    // end user is not aware of the notifications system at all
    if (!this.isSupported) return;

    // Register service worker for handling notifications
    navigator.serviceWorker
      .register(this.serviceWorkerUrlValue)
      .then((registration) => {
        this.serviceWorkerRegistration = registration;
        this.messaging = firebase.messaging();

        // Without loaded subscriptions, this will only show all "enable" buttons
        this.updateButtons();

        // init() might throw error about notifications being blocked in browser
        return this.init();
      })
      // Do not show any errors from initialization to user
      // These errors might include error during service worker registration
      // or notifications being blocked in browser.
      .catch(error => this.logError(error));
  }

  get isSupported() {
    // bail if firebase is not configured
    if (!firebase || !firebase.apps || firebase.apps.length === 0) return false;

    // bail if messaging is not supported
    return firebase.messaging.isSupported();
  }

  get allowed() {
    return localStorage.getItem(this.constructor.allowedNotificationsLocalStorageKey) === 'yes';
  }

  set allowed(value) {
    localStorage.setItem(this.constructor.allowedNotificationsLocalStorageKey, value ? 'yes' : 'no');
  }

  init() {
    if (!this.allowed)
      return Promise.reject(new Error(window.strings['notifications.errors.not_allowed']));

    return Promise.resolve()
      .then(() => this.loadUserId())
      .then(() => this._fetchSubscriptions())
      .then(res => this.processSubscriptionsResponse(res))
  }

  logError(error) {
    console.log('[RegionNotificationsController]', error.message || error.toString());
  }

  showError(error) {
    if (error.code === 'messaging/permission-blocked') {
      this.showErrorMessage(window.strings['notifications.errors.disabled_in_browser']);
      return;
    }

    console.log('[RegionNotificationsController]', error);
    this.showErrorMessage(error.message || error.toString());
  }

  showErrorMessage(message, title = window.strings['notifications.errors.title']) {
    window.showMessage(title, message, 'danger');
  }

  processSubscriptionsResponse(response) {
    return Promise.resolve(response.json())
      .then(data => this.subscriptions = data)
      .then(() => this.updateButtons());
  }

  /**
   * Updates visual state of all enable and disable button
   */
  updateButtons() {
    this.enableButtonTargets.forEach(button => this.updateButton(button, 'enableButton'));
    this.disableButtonTargets.forEach(button => this.updateButton(button, 'disableButton'));
  }

  /**
   * Updates visual state of one specific button based on current application state
   * @param button - button element
   * @param buttonType - can be 'enableButton' or 'disableButton'
   */
  updateButton(button, buttonType) {
    // When not allowed or subscriptions not loaded
    // show all subscribe buttons and hide all unsubscribe buttons
    if (!this.allowed || !this.subscriptions) {
      // subscribe button should be enabled end vice versa
      this.toggleButton(button, buttonType === 'enableButton');
      return;
    }

    const region_id = button.dataset.region;
    const subscription = this.subscriptions.find(subscription => subscription.region_id.toString() === region_id);

    // if subscription exists, disableButton should be visible
    // otherwise enableButton should be visible
    const isVisible = subscription ? buttonType === 'disableButton' : buttonType === 'enableButton';
    this.toggleButton(button, isVisible);
  }

  /**
   * Toggles button visually
   * @param button
   * @param isVisible
   */
  toggleButton(button, isVisible) {
    button.classList.toggle(this.enabledClass, isVisible);
    button.classList.toggle(this.disabledClass, !isVisible);
  }

  loadUserId() {
    return this.messaging
      .getToken({
        vapidKey: window.firebaseVapidKey,
        serviceWorkerRegistration: this.serviceWorkerRegistration,
      })
      .then(currentToken => {
        if (currentToken) {
          console.log('[RegionNotificationsController] currentToken', currentToken);
          this.userId = currentToken;
          return currentToken;
        } else {
          throw new Error('getToken did not return token, this should not happen');
        }
      });
  }

  allow() {
    this.allowed = true;
    return this.init();
  }

  /**
   * CONTROLLER ACTIONS
   */
  subscribe(event) {
    const region_id = event.currentTarget.dataset.region;

    return this.allow()
      .then(() => this._subscribeRegion(region_id))
      .then(res => this.processSubscriptionsResponse(res))
      .catch(err => this.showError(err));
  }

  unsubscribe(event) {
    const region_id = event.currentTarget.dataset.region;

    return this.allow()
      .then(() => this._unsubscribeRegion(region_id))
      .then(res => this.processSubscriptionsResponse(res))
      .catch(err => this.showError(err));
  }

  /**
   * API HELPERS
   */
  // get subscriptions
  _fetchSubscriptions() {
    if (!this.userId) throw new Error('UserId missing');

    return fetch(`${this.subscriptionsUrlValue}?channel=webpush&user_id=${this.userId}`)
  }

  // create subscription
  _subscribeRegion(region_id) {
    if (!this.userId) throw new Error('UserId missing');

    return fetch(this.subscriptionsUrlValue, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        channel: 'webpush',
        user_id: this.userId,
        region_id,
      }),
    });
  }

  // delete subscription
  _unsubscribeRegion(region_id) {
    if (!this.userId) throw new Error('UserId missing');

    const subscription = this.subscriptions.find((subscription) => subscription.region_id.toString() === region_id);
    return fetch(`${this.subscriptionsUrlValue}/${subscription.id}.json?user_id=${this.userId}&channel=webpush`, {method: 'DELETE'});
  }
}
