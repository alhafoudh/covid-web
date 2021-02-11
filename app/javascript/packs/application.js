import '../stylesheets/application.scss';
const images = require.context('../images', true)

import firebase from 'firebase/app';
import 'firebase/messaging';

window.firebase = firebase;

import "controllers"
