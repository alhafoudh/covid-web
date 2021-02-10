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

  showNotification({title, body, id}) {
    const note = this.notificationTemplateTarget.cloneNode(true);
    note.classList.remove('hidden');
    note.querySelector('[data-note-title]').innerHTML = title;
    note.querySelector('[data-note-body]').innerHTML = body;
    note.id = id;
    this.element.appendChild(note);

    setTimeout(() => {
      note.classList.add('mr-4')
      note.classList.remove('translate-x-full')
    }, 100)
  }

  hideNotification(element) {
    element.classList.add('translate-x-full')
    element.classList.remove('mr-4')

    setTimeout(() => {
      element.remove();
    }, 300)
  }

  /**
   * CONTROLLER ACTIONS
   */
  handleNotificationClick(event) {
    const noteElement = event.currentTarget;
    this.removeNotification(noteElement.id);
    this.hideNotification(noteElement);
  }
}
