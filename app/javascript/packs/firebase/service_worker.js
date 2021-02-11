import firebase from 'firebase/app';
import 'firebase/messaging';
import { storeNotifications, loadNotifications } from '../../lib/notifications_store';

console.log('Starting service worker');

self.firebase = firebase;

importScripts('/firebase/configuration.js');

const messaging = firebase.messaging();

self.addEventListener('push', event => {
  const payload = event.data.json();
  console.log('Message received on Background Raw', event, payload, new Date());

  loadNotifications()
    .then(function (notifications) {
      notifications.push(payload.data);
      return storeNotifications(notifications);
    })
    .then(function () {
      // Trigger empty message on client to ensure client refreshes list of messages
      clients
        .matchAll({includeUncontrolled: true, type: 'window'})
        .then(function (clientList) {
          if (clientList.length > 0) {
            const channel = new MessageChannel();
            clientList[0].postMessage("", [channel.port2]);
          }
        });
    });
});
