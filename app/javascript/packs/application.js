import '../stylesheets/application.scss';
import firebase from 'firebase/app';
import 'firebase/messaging';
import * as Sentry from "@sentry/browser";
import {Integrations} from "@sentry/tracing";
import "controllers"

const images = require.context('../images', true)

window.firebase = firebase;

if (window.sentryDsn) {
  Sentry.init({
    dsn: window.sentryDsn,

    // To set your release version
    integrations: [new Integrations.BrowserTracing()],

    // Set tracesSampleRate to 1.0 to capture 100%
    // of transactions for performance monitoring.
    // We recommend adjusting this value in production
    tracesSampleRate: 0.1,
  });
  window.Sentry = Sentry;
}

