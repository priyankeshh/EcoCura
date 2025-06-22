// Firebase configuration for EcoCura web app
const firebaseConfig = {
  apiKey: "AIzaSyDstBgDfTCSBgrR1Js3Lm2AKUsWiAirLyU",
  authDomain: "ecocura-e5ddd.firebaseapp.com",
  projectId: "ecocura-e5ddd",
  storageBucket: "ecocura-e5ddd.firebasestorage.app",
  messagingSenderId: "192005607529",
  appId: "1:192005607529:web:b2b154cb1bfed8539492f8",
  measurementId: "G-RF6HSQ64CQ"
};

// Initialize Firebase
import { initializeApp } from 'firebase/app';
import { getAnalytics } from 'firebase/analytics';

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
