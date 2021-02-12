import {Controller} from 'stimulus';
import {loadNotifications, storeNotifications} from '../lib/notifications_store';

export default class extends Controller {
  static targets = [
    'notificationTemplate',
  ];

  connect() {
    window.showMessage = this.showMessage.bind(this);
    navigator.serviceWorker.addEventListener('message', event => {
      console.log('Message received on Channel', event);
      this.showNotifications();
    });

    window.addEventListener('removeNotification', this.onRemoveNotification.bind(this), false)

    this.showNotifications();
  }

  onRemoveNotification(event) {
    this.removeNotification(event.detail.id);
  }

  removeNotification(id) {
    return loadNotifications()
      .then(notifications => storeNotifications(notifications.filter(note => note.id !== id)))
  }

  /**
   * VISUAL HELPERS
   */
  showNotifications() {
    return loadNotifications()
      .then(notifications => {
        notifications.map(note => {
          if (!document.getElementById(note.id)) {
            this.showNotification(note);
          }
        })
      });
  }

  showNotification(notification, style = 'info') {
    const element = this.notificationTemplateTarget.cloneNode(true);
    element.classList.remove('hidden');
    delete element.dataset.notificationsTarget;

    element.id = notification.id;
    element.dataset.notificationIdValue = notification.id;
    element.dataset.notificationTitleValue = notification.title;
    element.dataset.notificationBodyValue = notification.body;
    element.dataset.notificationLinkValue = notification.link ?? '';

    switch (style) {
      case "danger":
        element.classList.add('notification-danger');
        break;
      default:
        element.classList.add('notification-info');
        break;
    }

    this.element.appendChild(element);
  }

  /**
   * GLOBAL HELPERS
   */
  showMessage(title, body, style) {
    this.showNotification({
      id: new Date().getTime().toString(),
      title,
      body,
    }, style)
  }
}
