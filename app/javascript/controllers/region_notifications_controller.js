import {Controller} from 'stimulus';
import firebase from 'firebase/app';

export default class extends Controller {
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
    subscriptionsUrl: String,
  };

  connect() {
    if (!firebase.messaging.isSupported())
      return;

    this.messaging = firebase.messaging();

    this.updateAll = this.updateAll.bind(this);
    this.processSubscriptions = this.processSubscriptions.bind(this);

    this.updateAll();
  }

  updateAll() {
    this.updateInfoBox();

    if (!this.allowed)
      return;

    return Promise.resolve()
      .then(() => this.updateUserId())
      .then(() => this.updateSubscriptions());
  }

  updateSubscriptions() {
    return fetch(`${this.subscriptionsUrlValue}?channel=webpush&user_id=${this.userId}`)
      .then(this.processSubscriptions);
  }

  processSubscriptions(response) {
    return Promise.resolve()
      .then(() => response.json())
      .then((data) => this.subscriptions = data)
      .then(() => this.updateButtons());
  }

  updateInfoBox() {
    this.infoBoxTarget.classList.toggle(this.hideClass, this.allowed);
  }

  updateUserId() {
    return this.messaging
      .getToken({vapidKey: window.firebaseVapidKey})
      .then((currentToken) => {
        if (currentToken) {
          console.log(currentToken);
          return currentToken;
        } else {
          console.log('No registration token available. Request permission to generate one.');
          return null;
        }
      })
      .then((userId) => {
        this.userId = userId;
        return userId;
      })
      .catch((err) => {
        console.log('An error occurred while retrieving token. ', err);
        return null;
      });
  }

  updateButtons() {
    this.enableButtonTargets.forEach((element) => {
      const region_id = element.dataset.region;
      const subscription = this.subscriptions.find(subscription => subscription.region_id.toString() === region_id);

      element.classList.toggle(this.enabledClass, !!!subscription);
      element.classList.toggle(this.disabledClass, !!subscription);
    });

    this.disableButtonTargets.forEach((element) => {
      const region_id = element.dataset.region;
      const subscription = this.subscriptions.find(subscription => subscription.region_id.toString() === region_id);

      element.classList.toggle(this.enabledClass, !!subscription);
      element.classList.toggle(this.disabledClass, !!!subscription);
    });
  }

  get allowed() {
    return localStorage.getItem(this.constructor.allowedNotificationsLocalStorageKey) === 'yes';
  }

  set allowed(value) {
    localStorage.setItem(this.constructor.allowedNotificationsLocalStorageKey, value ? 'yes' : 'no');
  }

  allow() {
    this.allowed = true;
    this.updateAll();
  }

  subscribe(event) {
    const region_id = event.currentTarget.dataset.region;

    Promise.resolve()
      .then(() => fetch(this.subscriptionsUrlValue, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          channel: 'webpush',
          user_id: this.userId,
          region_id: region_id,
        }),
      }))
      .then(this.processSubscriptions);

  }

  unsubscribe(event) {
    const region_id = event.currentTarget.dataset.region;
    const subscription = this.subscriptions.find((subscription) => subscription.region_id.toString() === region_id);

    Promise.resolve()
      .then(() => fetch(`${this.subscriptionsUrlValue}/${subscription.id}.json`, {method: 'DELETE'}))
      .then(this.processSubscriptions);
  }
}
