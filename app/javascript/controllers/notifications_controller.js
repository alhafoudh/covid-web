import {Controller} from 'stimulus';
import firebase from 'firebase/app';

export default class extends Controller {
  static pendingNotificationsLocalStorageKey = "pendingNotifications";

  static targets = [
    'notificationTemplate',
  ];

  connect() {
    window.mockNotification = this.mockNotification.bind(this)

    this.loadNotifications().forEach(note => this.showNotification(note));
  }

  /**
   * STORAGE HELPERS
   */

  storeNotifications(notes) {
    const notesString = JSON.stringify(notes);
    localStorage.setItem(this.constructor.pendingNotificationsLocalStorageKey, notesString);
  }

  loadNotifications() {
    try {
      return JSON.parse(localStorage.getItem(this.constructor.pendingNotificationsLocalStorageKey)) || [];
    } catch (e) {
      console.log('could not load stored notifications', e);
    }
    return [];
  }

  addNotification(title, body) {
    const note = {title, body, id: new Date().getTime()};
    const notes = this.loadNotifications();
    notes.push(note);
    this.storeNotifications(notes);
    return note;
  }

  removeNotification(id) {
    this.storeNotifications(this.loadNotifications().filter(note => note.id !== id));
  }

  /**
   * VISUAL HELPERS
   */
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
    this.removeNotification(Number(noteElement.id));
    this.hideNotification(noteElement);
  }

  /**
   * DEVELOPMENT
   */

  mockNotification() {
    const note = this.addNotification(
      'Woo something happen at ' + Date.now().toString(),
      'Something happen and we now have so much room!<br /><strong>WOOO</strong>'
    );
    this.showNotification(note);
  }
}
