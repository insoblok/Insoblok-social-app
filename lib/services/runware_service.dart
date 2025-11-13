import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:insoblok/utils/utils.dart';

class RunwareService {
  final String baseUrl;
  final String apiKey;

  RunwareService({
    String? baseUrl,
    String? apiKey,
  })  : baseUrl = baseUrl ?? RUNWARE_BASE_URL,
        apiKey = apiKey ?? RUNWARE_API_KEY;

  Map<String, String> _authHeaders({Map<String, String>? extra}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      // Prefer Authorization; some deployments accept x-api-key only.
      'Authorization': 'Bearer $apiKey',
      'x-api-key': apiKey,
    };
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  Future<Uint8List> _downloadBytes(String url) async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Image download failed ${res.statusCode}');
    }
    return res.bodyBytes;
  }

  Future<String?> _postJson(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    http.Response res;
    try {
      res = await http.post(uri, headers: _authHeaders(), body: jsonEncode(body));
    } catch (e) {
      // Try without Authorization if a proxy in front only accepts x-api-key
      res = await http.post(uri, headers: {'Content-Type': 'application/json', 'x-api-key': apiKey}, body: jsonEncode(body));
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        // Response like: [{ videoURL: "..."}]
        if (decoded.isNotEmpty && decoded.first is Map) {
          final url = _extractVideoUrl(Map<String, dynamic>.from(decoded.first as Map));
          if (url != null) return url;
        }
        return null;
      } else if (decoded is Map) {
        final data = Map<String, dynamic>.from(decoded);
        // Common shapes:
        // - immediate: [{ url | videoURL }]
        // - task-based: { taskUUID }
        // - wrapped: { data: {...} }
        final directUrl = _extractVideoUrl(data);
        if (directUrl != null) return directUrl;
        final taskId = _extractTaskId(data);
        if (taskId != null) {
          return await pollTaskForUrl(taskId);
        }
        return null;
      }
    }
    throw Exception('Runware POST ${res.statusCode} ${res.body}');
  }

  String? _extractTaskId(Map<String, dynamic> json) {
    if (json['taskUUID'] is String) return json['taskUUID'] as String;
    if (json['data'] is Map && (json['data']['taskUUID'] is String)) {
      return json['data']['taskUUID'] as String;
    }
    return null;
    }

  String? _extractVideoUrl(Map<String, dynamic> json) {
    // Various possible response shapes
    if (json['videoURL'] is String) return json['videoURL'] as String;
    if (json['url'] is String) return json['url'] as String;
    if (json['data'] is Map) {
      final d = json['data'] as Map;
      if (d['videoURL'] is String) return d['videoURL'] as String;
      if (d['url'] is String) return d['url'] as String;
    }
    if (json['results'] is List && (json['results'] as List).isNotEmpty) {
      final m = (json['results'] as List).first;
      if (m is Map) {
        if (m['videoURL'] is String) return m['videoURL'] as String;
        if (m['url'] is String) return m['url'] as String;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getJson(String pathOrUrl) async {
    final uri = pathOrUrl.startsWith('http') ? Uri.parse(pathOrUrl) : Uri.parse('$baseUrl$pathOrUrl');
    final res = await http.get(uri, headers: _authHeaders());
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<String?> pollTaskForUrl(String taskUUID, {Duration interval = const Duration(seconds: 2), Duration timeout = const Duration(minutes: 3)}) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      // The actual status path can vary; include two common patterns.
      Map<String, dynamic>? statusJson = await _getJson('/v1/tasks/$taskUUID');
      statusJson ??= await _getJson('/tasks/$taskUUID');
      if (statusJson != null) {
        final url = _extractVideoUrl(statusJson) ?? _extractVideoUrl(_toStringKeyMap(statusJson['data']));
        if (url != null) return url;
        final status = (statusJson['status'] ?? statusJson['data']?['status'])?.toString().toUpperCase();
        if (status == 'FAILED' || status == 'ERROR') {
          throw Exception('Runware task failed');
        }
        if (status == 'COMPLETED' || status == 'DONE') {
          final maybe = _extractVideoUrl(statusJson);
          if (maybe != null) return maybe;
        }
      }
      await Future.delayed(interval);
    }
    throw Exception('Runware task timed out');
  }

  Map<String, dynamic> _toStringKeyMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  /// Generate a Seedance 1.0 Pro Fast video from a single image URL and a short prompt.
  ///
  /// Defaults are aligned with your preferred dashboard settings:
  ///  - 3:4 (360x480), mp4, 3 seconds, 24 fps, model bytedance:2@2.
  Future<String?> generateVideoFromImageUrl({
    required String imageUrl,
    required String prompt,
    int width = 360,
    int height = 480,
    int fps = 24,
    num durationSeconds = 3,
    String model = 'bytedance:2@2',
  }) async {
    // Download the source image and wrap as data URI
    final bytes = await _downloadBytes(_forceHttps(imageUrl));
    final mime = _guessMime(bytes, fallback: 'image/jpeg');
    final b64 = base64Encode(bytes);
    final dataUri = 'data:$mime;base64,$b64';

    return _generateVideoFromDataUri(
      dataUri: dataUri,
      prompt: prompt,
      width: width,
      height: height,
      fps: fps,
      durationSeconds: durationSeconds,
      model: model,
    );
  }

  Future<String?> generateVideoFromFile({
    required List<int> fileBytes,
    String mimeType = 'image/jpeg',
    required String prompt,
    int width = 360,
    int height = 480,
    int fps = 24,
    num durationSeconds = 3,
    String model = 'bytedance:2@2',
  }) async {
    final b64 = base64Encode(fileBytes);
    final dataUri = 'data:$mimeType;base64,$b64';
    return _generateVideoFromDataUri(
      dataUri: dataUri,
      prompt: prompt,
      width: width,
      height: height,
      fps: fps,
      durationSeconds: durationSeconds,
      model: model,
    );
  }

  Future<String?> _generateVideoFromDataUri({
    required String dataUri,
    required String prompt,
    required int width,
    required int height,
    required int fps,
    required num durationSeconds,
    required String model,
  }) async {
    // Two request styles
    final bodyDirect = <String, dynamic>{
      'model': model,
      'frameImages': [
        {'inputImage': dataUri, 'frame': 'first'}
      ],
      'positivePrompt': 'expression edit: $prompt',
      'duration': durationSeconds,
      'width': width,
      'height': height,
      'fps': fps,
      'outputType': 'URL',
      'outputFormat': 'MP4',
      'numberResults': 1,
    };

    final bodyTask = <String, dynamic>{
      'taskType': 'videoInference',
      'model': model,
      'frameImages': [
        {'inputImage': dataUri, 'frame': 'first'}
      ],
      'positivePrompt': 'expression edit: $prompt',
      'duration': durationSeconds,
      'width': width,
      'height': height,
      'fps': fps,
      'outputType': 'URL',
      'outputFormat': 'MP4',
      'numberResults': 1,
    };

    // Try direct inference endpoints first
    final directPaths = <String>[
      '/v1/video/inference',
      '/video/inference',
      '/v1/videoInference',
      '/videoInference',
    ];
    for (final path in directPaths) {
      try {
        final url = await _postJson(path, bodyDirect);
        if (url != null && url.isNotEmpty) return url;
      } catch (_) {}
    }

    // Then task-based fallbacks
    final taskPaths = <String>[
      '/v1/tasks',
      '/tasks',
      '/v1/task',
      '/task',
    ];
    for (final path in taskPaths) {
      try {
        final url = await _postJson(path, bodyTask);
        if (url != null && url.isNotEmpty) return url;
      } catch (_) {}
    }

    throw Exception('No valid Runware endpoint responded');
  }
  String _forceHttps(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.scheme == 'http') {
        return uri.replace(scheme: 'https').toString();
      }
      return url;
    } catch (_) {
      return url;
    }
  }
  String _guessMime(Uint8List bytes, {String fallback = 'application/octet-stream'}) {
    if (bytes.length >= 3) {
      // PNG
      if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E) return 'image/png';
      // JPG
      if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'image/jpeg';
      // WEBP
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46 &&
          bytes[8] == 0x57 &&
          bytes[9] == 0x45 &&
          bytes[10] == 0x42 &&
          bytes[11] == 0x50) return 'image/webp';
    }
    return fallback;
  }
}


