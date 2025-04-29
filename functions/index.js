/* eslint-disable eol-last */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const WebSocket = require("ws");
admin.initializeApp();

const perigonSocket = new WebSocket("wss://api.perigon.io/v1/ws");

// Store API key in Firebase config (set via: firebase functions:config:set perigon.key="YOUR_KEY")
const API_KEY = functions.config().perigon.key;

perigonSocket.on("open", () => {
  console.log("Connected to Perigon.io");
  
  // Authenticate
  perigonSocket.send(JSON.stringify({
    action: "auth",
    api_key: API_KEY
  }));
  
  // Subscribe to channels
  perigonSocket.send(JSON.stringify({
    action: "subscribe",
    channel: "news"
  }));
});

perigonSocket.on("message", async (data) => {
  try {
    const message = JSON.parse(data);
    
    if (message.type === "news") {
      // Store news in Firestore
      await admin.firestore().collection("perigonNews").add({
        ...message.payload,
        receivedAt: admin.firestore.FieldValue.serverTimestamp(),
        processed: false
      });
      
      // Optional: Trigger additional processing
      await admin.firestore().collection("tasks").add({
        type: "process_news",
        newsId: message.payload.id,
        createdAt: admin.firestore.FieldValue.serverTimestamp()
      });
    }
  } catch (error) {
    console.error("Error processing message:", error);
  }
});

perigonSocket.on("error", (error) => {
  console.error("WebSocket error:", error);
  // Implement appropriate fallback or notification
});

// Keep the function running
exports.perigonListener = functions.https.onRequest((req, res) => {
  res.status(200).send("Perigon.io WebSocket listener active");
});

// Cleanup on function termination
process.on("SIGTERM", () => {
  perigonSocket.close();
  console.log("Perigon.io connection closed");
});