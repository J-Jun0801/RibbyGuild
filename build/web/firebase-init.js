// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyC6gLODirru5Rb9oNSeArZJll9SG_pRjjg",
  authDomain: "ribbyguild.firebaseapp.com",
  projectId: "ribbyguild",
  storageBucket: "ribbyguild.firebasestorage.app",
  messagingSenderId: "93104993339",
  appId: "1:93104993339:web:48f5dd15a23afc99e5181e",
  measurementId: "G-Q62JTBFCE0"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);