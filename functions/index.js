/* eslint-disable eol-last */
const axios = require("axios");
const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
admin.initializeApp();

const API_KEY = functions.config().perigon.key;
const fromDate = new Date(Date.now() - 3600000 * 3).toISOString();
const url = `https://api.goperigon.com/v1/all?q=recall%20OR%20%22safety%20concern%2A%22&title=tesla%20OR%20TSLA%20OR%20%22General%20Motors%22%20OR%20GM&sortBy=relevance&from=${fromDate}&apiKey=${API_KEY}`;

exports.scheduledFunction = functions.pubsub
    .schedule("every 3 hours")
    .timeZone("America/New_York")
    .onRun((context) => {
      console.log("This will run every 3 hours!");
      axios.get(url)
          .then((data) => {
            console.log(data);
            admin.firestore().collection("perigonNews").add({
              ...data,
              receivedAt: admin.firestore.FieldValue.serverTimestamp(),
              processed: false,
            });
          })
          .catch((error) => {
            console.log(error);
          });
      return null;
    });