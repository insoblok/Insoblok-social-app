/* eslint-disable eol-last */
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
// v2 APIs
const {onInit} = require("firebase-functions/v2/core");
const {onCall, onRequest} = require("firebase-functions/v2/https");
// const {onSchedule} = require("firebase-functions/v2/scheduler");

// Defer initialization to onInit to avoid deployment discovery timeouts
onInit(async () => {
  try {
    if (admin.apps.length === 0) {
      admin.initializeApp();
    }
  } catch (e) {
    // Already initialized or environment issue; log and continue
    logger.warn("Admin init warning", e);
  }
});

// Removed Perigon scheduler sample to simplify deployment

// Renamed to avoid 1st gen->2nd gen upgrade conflict on existing deployment
// Disabled Perigon scheduled ingest to simplify deployment and avoid Scheduler IAM requirements.

// --- Stream Video (Live Streaming) backend helpers ---
const crypto = require("crypto");
const {StreamVideoServerClient} = require("@stream-io/node-sdk");

// Read from functions.config() if available, else env (supports dotenv migration)
let STREAM_API_KEY = process.env.STREAM_KEY;
let STREAM_API_SECRET = process.env.STREAM_SECRET;
try {
  // functions.config() only exists in Firebase environments
  const functionsV1 = require("firebase-functions");
  const cfg = functionsV1.config && functionsV1.config();
  if (cfg && cfg.stream) {
    STREAM_API_KEY = STREAM_API_KEY || cfg.stream.key;
    STREAM_API_SECRET = STREAM_API_SECRET || cfg.stream.secret;
  }
} catch (_) {
  // ignore local require failure
}

let streamVideoClient = null;
function getStreamVideoClient() {
  if (!STREAM_API_KEY || !STREAM_API_SECRET) {
    throw new Error("Missing Stream config. Set with: firebase functions:config:set stream.key=YOUR_KEY stream.secret=YOUR_SECRET");
  }
  if (!streamVideoClient) {
    streamVideoClient = new StreamVideoServerClient({
      apiKey: STREAM_API_KEY,
      secret: STREAM_API_SECRET,
    });
  }
  return streamVideoClient;
}

// Issue a Stream Video user token for the authenticated Firebase user
exports.videoTokenV2 = onCall(async (request) => {
  const context = request;
  if (!context.auth) {
    const {HttpsError} = require("firebase-functions/v2/https");
    throw new HttpsError("unauthenticated", "Must be authenticated");
  }
  const userId = context.auth.uid;
  const expirationSeconds = Number(request.data && request.data.expiresInSeconds) || 60 * 60 * 24; // 24h
  const client = getStreamVideoClient();
  // createToken(userId, expSeconds)
  const token = client.createToken(userId, expirationSeconds);
  return {token, apiKey: STREAM_API_KEY, userId};
});

// Create a livestream call server-side (optional; you can also create on the client)
exports.createLivestreamCallV2 = onCall(async (request) => {
  const context = request;
  const {HttpsError} = require("firebase-functions/v2/https");
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated");
  }
  const callId = (request.data && request.data.callId) || null;
  if (!callId) {
    throw new HttpsError("invalid-argument", "callId is required");
  }
  try {
    const client = getStreamVideoClient();
    const call = client.video.call("livestream", callId);
    await call.getOrCreate({
      create: {
        custom: {createdBy: context.auth.uid, title: request.data && request.data.title ? request.data.title : ""},
      },
    });
    await admin.firestore().collection("stream_calls").add({
      callId,
      createdBy: context.auth.uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return {callId};
  } catch (e) {
    await admin.firestore().collection("stream_call_errors").add({
      callId,
      error: String(e && e.message ? e.message : e),
      at: admin.firestore.FieldValue.serverTimestamp(),
    });
    throw new HttpsError("internal", "Failed to create livestream call");
  }
});

// Webhook endpoint to receive Stream Video events (configure this URL in Stream dashboard)
exports.streamWebhookV2 = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).send("Method Not Allowed");
  }
  try {
    const signature = req.get("X-Stream-Signature") || req.get("X-Signature");
    if (!signature) {
      return res.status(401).send("Missing signature");
    }
  const expected = crypto
        .createHmac("sha256", STREAM_API_SECRET)
        .update(req.rawBody)
        .digest("hex");
    if (signature !== expected) {
      return res.status(401).send("Invalid signature");
    }

    const payload = req.body || JSON.parse(Buffer.from(req.rawBody).toString("utf8"));
    await admin.firestore().collection("stream_webhooks").add({
      payload,
      receivedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return res.status(200).send("ok");
  } catch (err) {
    logger.error("Webhook handling error", err);
    return res.status(500).send("error");
  }
});