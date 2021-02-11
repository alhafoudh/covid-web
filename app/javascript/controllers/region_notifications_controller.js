import {Controller} from 'stimulus';
import firebase from 'firebase/app';

export default class extends Controller {
  static featureEnabledLocalStorageKey = "region_notifications.feature_enabled";
  static allowedNotificationsLocalStorageKey = "region_notifications.allowed_notifications";

  static targets = [
    'enableButton',
    'disableButton',
    'infoBox',
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
    if (!this.featureEnabled)
      return;
    
    // bail if firebase is not configured
    if (firebase.apps.length === 0)
      return;

    // bail if messaging is not supported
    if (!firebase.messaging.isSupported())
      return;

    navigator.serviceWorker
      .register(this.serviceWorkerUrlValue)
      .then((registration) => {
        this.serviceWorkerRegistration = registration;
        this.messaging = firebase.messaging();

        this.init();

        if (!this.allowed) {
          // show info box with slight delay
          setTimeout(() => {
            this.toggleInfoBox(true);
          }, 500);
        }
      })
      .catch((error) => console.log(error));
  }

  get featureEnabled() {
    return localStorage.getItem(this.constructor.featureEnabledLocalStorageKey) === 'yes';
  }

  get allowed() {
    return localStorage.getItem(this.constructor.allowedNotificationsLocalStorageKey) === 'yes';
  }

  set allowed(value) {
    localStorage.setItem(this.constructor.allowedNotificationsLocalStorageKey, value ? 'yes' : 'no');
  }

  init() {
    if (!this.allowed)
      return;

    return Promise.resolve()
      .then(() => this.loadUserId())
      .then(() => this._fetchSubscriptions())
      .then(res => this.processSubscriptionsResponse(res))
      .catch(err => this.processError(err));
  }

  processError(error) {
    // ignore if user declined messaging permission
    if (error.code === 'messaging/permission-blocked') return;

    console.log('[RegionNotificationsController]', error);
  }

  processSubscriptionsResponse(response) {
    return Promise.resolve()
      .then(() => response.json())
      .then(data => this.subscriptions = data)
      .then(() => this.updateButtons());
  }

  toggleInfoBox(visible) {
    if (visible) {
      this.infoBoxTarget.classList.add('max-h-80')
      this.infoBoxTarget.classList.add('opacity-100')
      this.infoBoxTarget.classList.add('scale-y-100')
    } else {
      this.infoBoxTarget.classList.remove('max-h-80')
      this.infoBoxTarget.classList.remove('opacity-100')
      this.infoBoxTarget.classList.remove('scale-y-100')
    }
  }

  updateButtons() {
    this.enableButtonTargets.forEach((element) => {
      const region_id = element.dataset.region;
      const subscription = this.subscriptions.find(subscription => subscription.region_id.toString() === region_id);

      element.classList.toggle(this.enabledClass, !subscription);
      element.classList.toggle(this.disabledClass, !!subscription);
    });

    this.disableButtonTargets.forEach((element) => {
      const region_id = element.dataset.region;
      const subscription = this.subscriptions.find(subscription => subscription.region_id.toString() === region_id);

      element.classList.toggle(this.enabledClass, !!subscription);
      element.classList.toggle(this.disabledClass, !subscription);
    });
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
      })
      .finally(() => this.toggleInfoBox(false));
  }

  /**
   * CONTROLLER ACTIONS
   */
  allow() {
    this.allowed = true;
    this.init();
  }

  subscribe(event) {
    const region_id = event.currentTarget.dataset.region;

    return Promise.resolve()
      .then(() => this._subscribeRegion(region_id))
      .then(res => this.processSubscriptionsResponse(res))
      .catch(err => this.processError(err));
  }

  unsubscribe(event) {
    const region_id = event.currentTarget.dataset.region;

    Promise.resolve()
      .then(() => this._unsubscribeRegion(region_id))
      .then(res => this.processSubscriptionsResponse(res))
      .catch(err => this.processError(err));
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
