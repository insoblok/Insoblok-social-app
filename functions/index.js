/* eslint-disable eol-last */
const logger = require("firebase-functions/logger");

const axios = require("axios");
const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
admin.initializeApp();

const API_KEY = "8f022782-50f7-4e15-8485-7c913f9e6f09";
const fromDate = new Date(Date.now() - 3600000 * 3).toISOString();
const url = `https://api.goperigon.com/v1/all?q=recall%20OR%20%22safety%20concern%2A%22&title=tesla%20OR%20TSLA%20OR%20%22General%20Motors%22%20OR%20GM&sortBy=relevance&from=${fromDate}&apiKey=${API_KEY}`;

exports.scheduledFunction = functions.pubsub
    .schedule("every 3 hours")
    .timeZone("America/New_York")
    .onRun((context) => {
      logger.info("This will run every 3 hours!");
      axios.get(url)
          .then(async (response) => {
            const data = response.data;
            logger.info(data["articles"].length);
            for (let i = 0; i < data["articles"].length; i++) {
              const article = data["articles"][i];
              logger.info(article);
              await admin.firestore().collection("perigon").add({
                ...article,
              });
            }
          })
          .catch((error) => {
            logger.error(error);
          });
      return null;
    });