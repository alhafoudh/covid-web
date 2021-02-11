import {Controller} from 'stimulus';
import localforage from 'localforage';

export default class extends Controller {
  static notificationsDatabaseKey = 'notifications.db';

  static targets = [
    'notificationTemplate',
  ];

  connect() {
    navigator.serviceWorker.addEventListener('message', event => {
      console.log('Message received on Channel', event);
      this.showNotifications();
    });

    window.addEventListener('removeNotification', this.onRemoveNotification.bind(this), false)

    this.showNotifications();
  }

  /**
   * STORAGE HELPERS
   */
  storeNotifications(notifications) {
    const payload = JSON.stringify(notifications);
    return localforage.setItem(this.constructor.notificationsDatabaseKey, payload);
  }

  loadNotifications() {
    return localforage.getItem(this.constructor.notificationsDatabaseKey)
      .then((payload) => {
        try {
          return JSON.parse(payload) || [];
        } catch (e) {
          console.log('could not load stored notifications', e);
        }
        return [];
      })
  }

  onRemoveNotification(event) {
    this.removeNotification(event.detail.id);
  }

  removeNotification(id) {
    return this.loadNotifications()
      .then(notifications => this.storeNotifications(notifications.filter(note => note.id !== id)))
  }

  /**
   * VISUAL HELPERS
   */
  showNotifications() {
    return this.loadNotifications()
      .then(notifications => {
        notifications.map(note => {
          if (!document.getElementById(note.id)) {
            this.showNotification(note);
          }
        })
      });
  }

  showNotification(notification) {
    const element = this.notificationTemplateTarget.cloneNode(true);
    element.classList.remove('hidden');
    delete element.dataset.notificationsTarget;

    element.id = notification.id;
    element.dataset.notificationIdValue = notification.id;
    element.dataset.notificationTitleValue = notification.title;
    element.dataset.notificationBodyValue = notification.body;
    element.dataset.notificationLinkValue = notification.link ?? '';
    this.element.appendChild(element);
  }
}
