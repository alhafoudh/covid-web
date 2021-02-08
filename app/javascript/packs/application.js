import '../stylesheets/application.scss';
const images = require.context('../images', true)

import firebase from 'firebase/app';
import 'firebase/messaging';

import "controllers"

// Initialize Firebase
firebase.initializeApp(window.firebaseConfig);
