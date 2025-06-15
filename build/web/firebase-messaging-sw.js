// Firebase 초기화 (firebaseConfig와 동일해야 함)
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyC6gLODirru5Rb9oNSeArZJll9SG_pRjjg",
  authDomain: "ribbyguild.firebaseapp.com",
  projectId: "ribbyguild",
  messagingSenderId: "93104993339",
  appId: "1:93104993339:web:48f5dd15a23afc99e5181e",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
