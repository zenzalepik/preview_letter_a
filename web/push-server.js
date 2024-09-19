const webPush = require('web-push');

const vapidKeys = {
  publicKey: '<YOUR_PUBLIC_VAPID_KEY>',
  privateKey: '<YOUR_PRIVATE_VAPID_KEY>'
};

webPush.setVapidDetails(
  'mailto:example@example.com',
  vapidKeys.publicKey,
  vapidKeys.privateKey
);

const pushSubscription = {
  endpoint: '<SUBSCRIBER_ENDPOINT>',
  keys: {
    p256dh: '<P256DH_KEY>',
    auth: '<AUTH_KEY>'
  }
};

const payload = JSON.stringify({
  title: 'Push Notification Title',
  body: 'Push Notification Body',
  icon: 'icon.png',
  badge: 'badge.png'
});

webPush.sendNotification(pushSubscription, payload)
  .then(response => console.log('Push sent:', response))
  .catch(error => console.error('Error sending push:', error));
