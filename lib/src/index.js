// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, collection , getDocs , getDoc } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAxSDHPY3PL6uD_nQPNmxyEXSSFQLgiaok",
  authDomain: "referee-application.firebaseapp.com",
  projectId: "referee-application",
  storageBucket: "referee-application.firebasestorage.app",
  messagingSenderId: "932425915689",
  appId: "1:932425915689:web:33c28be5e33a9f2d5ceb38",
  measurementId: "G-XPSEMRK4KN"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);
const refereeCollection = collection(db, "test");
const snapshot = await getDocs(refereeCollection);