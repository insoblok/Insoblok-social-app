/* eslint-disable eol-last */
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
// v2 APIs
const {onInit} = require("firebase-functions/v2/core");
const {onCall, onRequest} = require("firebase-functions/v2/https");
// const {onSchedule} = require("firebase-functions/v2/scheduler");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

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
// Use CJS require first (preferred if available), then dynamic import fallback for ESM

// Resolve Stream credentials: prefer functions config stream.key/stream.secret, then env fallbacks.
let STREAM_API_KEY = null;
let STREAM_API_SECRET = null;
try {
  const functionsV1 = require("firebase-functions");
  const cfg = functionsV1.config && functionsV1.config();
  if (cfg && cfg.stream) {
    // Primary keys we want to use
    STREAM_API_KEY = cfg.stream.key || null;
    STREAM_API_SECRET = cfg.stream.secret || null;
    // Explicitly ignore legacy fields (api_key/api_secret) to avoid mismatched apps
  }
} catch (_) {
  // ignore local require failure
}
// Fallback to env if not found in functions config
STREAM_API_KEY = STREAM_API_KEY || process.env.STREAM_KEY || process.env.STREAM_API_KEY || null;
STREAM_API_SECRET = STREAM_API_SECRET || process.env.STREAM_SECRET || process.env.STREAM_API_SECRET || null;

let streamVideoClient = null;
async function getStreamVideoClient() {
  if (!STREAM_API_KEY || !STREAM_API_SECRET) {
    throw new Error("Missing Stream config. Set with: firebase functions:config:set stream.key=YOUR_KEY stream.secret=YOUR_SECRET");
  }
  if (!streamVideoClient) {
    let sdk;
    let StreamCtor;
    try {
      sdk = require("@stream-io/node-sdk");
      StreamCtor = sdk.StreamClient || (sdk.default && sdk.default.StreamClient);
    } catch (_) {
      const esm = await import("@stream-io/node-sdk");
      sdk = esm;
      StreamCtor = esm.StreamClient || (esm.default && esm.default.StreamClient);
    }
    if (!StreamCtor) {
      const keys = Object.keys(sdk || {});
      throw new Error("StreamClient not found from @stream-io/node-sdk import. Export keys: " + keys.join(","));
    }
    const basePath = process.env.STREAM_VIDEO_BASE_URL || process.env.STREAM_BASE_URL || process.env.STREAM_URL || process.env.STREAM_API_BASE_URL || process.env.STREAM_IO_API_BASE_URL || "https://video.stream-io-api.com";
    const timeout = Number(process.env.STREAM_TIMEOUT_MS || process.env.STREAM_TIMEOUT || 15000);
    streamVideoClient = new StreamCtor(STREAM_API_KEY, STREAM_API_SECRET, { timeout, basePath });
    try {
      const masked = (STREAM_API_KEY || "").slice(-4);
      logger.log("Stream client initialized", { basePath, timeout, apiKeySuffix: masked });
    } catch (e) {
      logger.warn("Stream client init log failed", e);
    }
  }
  return streamVideoClient;
}

// Issue a Stream Video user token for the authenticated Firebase user
exports.videoTokenV2 = onCall({ enforceAppCheck: true }, async (request) => {
  const context = request;
  if (!context.auth) {
    const {HttpsError} = require("firebase-functions/v2/https");
    throw new HttpsError("unauthenticated", "Must be authenticated");
  }
  // Optional: log app check info for debugging
  logger.log("AppCheck: ", context.app);
  const userId = context.auth.uid;
  const expirationSeconds = Number(request.data && request.data.expiresInSeconds) || 60 * 60 * 24; // 24h
  try {
    const client = await getStreamVideoClient();
    logger.log("Issuing Stream token", { userId, expirationSeconds });
    const token = client.generateUserToken({ user_id: userId, validity_in_seconds: expirationSeconds });
    return {token, apiKey: STREAM_API_KEY, userId};
  } catch (e) {
    logger.error("videoTokenV2 error", e);
    const {HttpsError} = require("firebase-functions/v2/https");
    throw new HttpsError("internal", "Failed to create video token");
  }
});

// Create a livestream call server-side (optional; you can also create on the client)
exports.createLivestreamCallV2 = onCall({ enforceAppCheck: true }, async (request) => {
  const context = request;
  const {HttpsError} = require("firebase-functions/v2/https");
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated");
  }
  logger.log("AppCheck: ", context.app);
  const callId = (request.data && request.data.callId) || null;
  if (!callId) {
    throw new HttpsError("invalid-argument", "callId is required");
  }
  try {
    logger.log("createLivestreamCallV2 begin", { callId, userId: context.auth.uid });
    const client = await getStreamVideoClient();
    const call = client.video.call("livestream", callId);
    await call.getOrCreate({
      create: {
        data: {
          created_by_id: context.auth.uid,
          custom: {
            title: request.data && request.data.title ? request.data.title : "",
          },
        },
      },
    });
    logger.log("createLivestreamCallV2 success", { callId });
    try {
      await admin.firestore().collection("stream_calls").add({
        callId,
        createdBy: context.auth.uid,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (fireErr) {
      logger.warn("stream_calls log write failed", fireErr);
    }
    return {callId};
  } catch (e) {
    logger.error("createLivestreamCallV2 error", e);
    try {
      await admin.firestore().collection("stream_call_errors").add({
        callId,
        error: String(e && e.message ? e.message : e),
        at: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (fireErr) {
      logger.error("stream_call_errors log write failed", fireErr);
    }
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

// Fan-out FCM push when an in-app notification document is created
exports.pushOnNotificationCreated = onDocumentCreated("notifications/{id}", async (event) => {
  try {
    const snap = event.data;
    if (!snap) return;
    const payload = snap.data();
    if (!payload) return;
    const toUserId = payload.toUserId;
    if (!toUserId) return;

    // Resolve device tokens from user doc
    const userDoc = await admin.firestore().collection("users2").doc(toUserId).get();
    const user = userDoc.data() || {};
    const tryArrays = [
      user.fcmTokens,
      user.deviceTokens,
      user.pushTokens,
      user.tokens,
    ];
    const tokens = Array.from(
      new Set(
        (tryArrays.flat().filter((t) => typeof t === "string") || []),
      ),
    );
    if (!tokens.length) {
      logger.log("No device tokens for user", {toUserId});
      return;
    }

    const title =
      (payload.type === "live_start") ?
        `${payload.fromUserName || "Someone"} is live` :
        (payload.title || "Notification");
    const body =
      (payload.type === "live_start") ?
        (payload.title ? `${payload.title}` : "Tap to join the stream") :
        (payload.body || "");

    const message = {
      notification: {title, body},
      data: {
        type: String(payload.type || ""),
        sessionId: String(payload.sessionId || ""),
        fromUserId: String(payload.fromUserId || ""),
      },
      android: {priority: "high"},
      apns: {payload: {aps: {sound: "default"}}},
      tokens,
    };

    const res = await admin.messaging().sendEachForMulticast(message);
    logger.log("pushOnNotificationCreated result", {
      success: res.successCount,
      failure: res.failureCount,
    });
  } catch (e) {
    logger.error("pushOnNotificationCreated error", e);
  }
});