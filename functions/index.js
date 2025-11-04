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
// Use CJS require first (preferred if available), then dynamic import fallback for ESM

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
async function getStreamVideoClient() {
  if (!STREAM_API_KEY || !STREAM_API_SECRET) {
    throw new Error("Missing Stream config. Set with: firebase functions:config:set stream.key=YOUR_KEY stream.secret=YOUR_SECRET");
  }
  if (!streamVideoClient) {
    let sdk;
    let Ctor;
    try {
      // Try commonjs build path (package may publish CJS alongside ESM)
      sdk = require("@stream-io/node-sdk/dist/index.cjs");
      Ctor = sdk.StreamVideoServerClient || sdk.StreamVideoClient || sdk.StreamClient || sdk.default;
    } catch (_) {
      // Fallback to ESM
      sdk = await import("@stream-io/node-sdk");
      Ctor = sdk.StreamVideoServerClient || sdk.StreamVideoClient || sdk.StreamClient || (sdk.default && (sdk.default.StreamVideoServerClient || sdk.default.StreamVideoClient || sdk.default.StreamClient)) || sdk.default;
    }
    if (!Ctor) {
      const keys = Object.keys(sdk || {});
      throw new Error("StreamVideoServerClient ctor not found from @stream-io/node-sdk import. Export keys: " + keys.join(","));
    }
    // Allow overriding base URL via multiple commonly used env var names; otherwise use the public default
    const baseUrl = process.env.STREAM_VIDEO_BASE_URL || process.env.STREAM_BASE_URL || process.env.STREAM_URL || process.env.STREAM_API_BASE_URL || process.env.STREAM_IO_API_BASE_URL || "https://video.stream-io-api.com";
    // Use object form first to ensure options like baseUrl/timeoutMs are applied across SDK variants
    const timeoutMs = Number(process.env.STREAM_TIMEOUT_MS || 15000);
    try {
      streamVideoClient = new Ctor({ apiKey: STREAM_API_KEY, apiSecret: STREAM_API_SECRET, secret: STREAM_API_SECRET, baseUrl, timeoutMs });
    } catch (_) {
      try {
        // Fallback: some versions accept (apiKey, apiSecret, options)
        streamVideoClient = new Ctor(STREAM_API_KEY, STREAM_API_SECRET, { baseUrl, timeoutMs });
      } catch (e2) {
        throw new Error("Failed to instantiate Stream video client: " + (e2?.message || e2));
      }
    }
    try {
      const masked = (STREAM_API_KEY || "").slice(-4);
      logger.log("Stream client initialized", { baseUrl, timeoutMs, apiKeySuffix: masked });
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
    // createToken(userId, expSeconds)
    const token = client.createToken(userId, expirationSeconds);
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
    // Support both client.video.call(...) and client.call(...) with bound context
    const boundCallFactory = (client.video && typeof client.video.call === "function") ? client.video.call.bind(client.video) : (typeof client.call === "function" ? client.call.bind(client) : null);
    if (!boundCallFactory) {
      throw new Error("Stream video client does not expose a call factory (video.call or call)");
    }
    const call = boundCallFactory("livestream", callId);
    await call.getOrCreate({
      create: {
        custom: {createdBy: context.auth.uid, title: request.data && request.data.title ? request.data.title : ""},
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