import localforage from 'localforage';

const notificationsDatabaseKey = 'notifications.db';

function storeNotifications(notifications) {
  const payload = JSON.stringify(notifications);
  return localforage.setItem(notificationsDatabaseKey, payload);
}

function loadNotifications() {
  return localforage.getItem(notificationsDatabaseKey)
    .then((payload) => {
      try {
        return JSON.parse(payload) || [];
      } catch (e) {
        console.log('could not load stored notifications', e);
      }
      return [];
    })
}

export { storeNotifications, loadNotifications };
