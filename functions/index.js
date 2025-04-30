/* eslint-disable eol-last */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const WebSocket = require("ws");
admin.initializeApp();

const perigonSocket = new WebSocket("wss://api.perigon.io/v1/ws");

const API_KEY = functions.config().perigon.key;

perigonSocket.on("open", () => {
  console.log("Connected to Perigon.io");
  perigonSocket.send(JSON.stringify({
    action: "auth",
    api_key: API_KEY,
  }));
  perigonSocket.send(JSON.stringify({
    action: "subscribe",
    channel: "news",
  }));
});

perigonSocket.on("message", async (data) => {
  try {
    const message = JSON.parse(data);
    if (message.type === "news") {
      await admin.firestore().collection("perigonNews").add({
        ...message.payload,
        receivedAt: admin.firestore.FieldValue.serverTimestamp(),
        processed: false,
      });
      await admin.firestore().collection("tasks").add({
        type: "process_news",
        newsId: message.payload.id,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  } catch (error) {
    console.error("Error processing message:", error);
  }
});

perigonSocket.on("error", (error) => {
  console.error("WebSocket error:", error);
});

exports.perigonListener = functions.https.onRequest((req, res) => {
  res.status(200).send("Perigon.io WebSocket listener active");
});

process.on("SIGTERM", () => {
  perigonSocket.close();
  console.log("Perigon.io connection closed");
});