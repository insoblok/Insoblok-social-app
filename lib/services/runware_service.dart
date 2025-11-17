import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:insoblok/utils/utils.dart';
import 'package:uuid/uuid.dart';

/// Supported avatar styles mapped to ByteDance models/prompts.
enum AvatarStyle {
	seededit3d,
	seedream3d,
	seedreamAnime,
	seedreamNeonGlow,
}

class RunwareService {
  final String baseUrl;
  final String apiKey;

  RunwareService({String? baseUrl, String? apiKey})
    : baseUrl = baseUrl ?? RUNWARE_BASE_URL,
      apiKey = apiKey ?? RUNWARE_API_KEY;

  Map<String, String> _authHeaders({Map<String, String>? extra}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
      res = await http.post(
        uri,
        headers: _authHeaders(),
        body: jsonEncode(body),
      );
    } catch (e) {
      // Try without Authorization if a proxy in front only accepts x-api-key
      res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'x-api-key': apiKey},
        body: jsonEncode(body),
      );
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        // Response like: [{ videoURL: "..."}]
        if (decoded.isNotEmpty && decoded.first is Map) {
          final url = _extractVideoUrl(
            Map<String, dynamic>.from(decoded.first as Map),
          );
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
    // For non-2xx, return null so caller can try next path; include status in print for debugging
    // ignore: avoid_print
    print('Runware POST $path -> HTTP ${res.statusCode} ${res.reasonPhrase}');
    return null;
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
    final uri =
        pathOrUrl.startsWith('http')
            ? Uri.parse(pathOrUrl)
            : Uri.parse('$baseUrl$pathOrUrl');
    final res = await http.get(uri, headers: _authHeaders());
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<String?> pollTaskForUrl(
    String taskUUID, {
    Duration interval = const Duration(seconds: 2),
    Duration timeout = const Duration(minutes: 3),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      // The actual status path can vary; include two common patterns.
      Map<String, dynamic>? statusJson = await _getJson('/v1/tasks/$taskUUID');
      statusJson ??= await _getJson('/tasks/$taskUUID');
      if (statusJson != null) {
        final url =
            _extractVideoUrl(statusJson) ??
            _extractVideoUrl(_toStringKeyMap(statusJson['data']));
        if (url != null) return url;
        final status =
            (statusJson['status'] ?? statusJson['data']?['status'])
                ?.toString()
                .toUpperCase();
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
    // Ensure API-compatible dimensions for Seedance 1.0 Pro Fast (bytedance:2@2)
    final dims = _pickCompatibleDimensions(width, height, model);
    final apiWidth = dims.$1;
    final apiHeight = dims.$2;
    final String taskUUID = const Uuid().v4();

    // 1) Minimal body per docs
    final bodyMinimal = <String, dynamic>{
      'taskUUID': taskUUID,
      'model': model,
      'frameImages': [
        {'inputImage': dataUri, 'frame': 'first'},
      ],
      'positivePrompt': 'expression edit: $prompt',
      'duration': durationSeconds.toDouble(),
      'width': apiWidth,
      'height': apiHeight,
    };

    // 2) SDK-style body (some deployments accept these additional fields)
    final bodySdk = <String, dynamic>{
      'taskUUID': taskUUID,
      'model': model,
      'frameImages': [
        {'inputImage': dataUri, 'frame': 'first'},
      ],
      'positivePrompt': 'expression edit: $prompt',
      'duration': durationSeconds.toDouble(),
      'width': apiWidth,
      'height': apiHeight,
      'fps': fps,
      'outputType': 'URL',
      'outputFormat': 'MP4',
      'numberResults': 1,
      'providerSettings': {
        'bytedance': {'cameraFixed': false},
      },
    };

    final bodyTaskMinimal = <String, dynamic>{
      'taskType': 'videoInference',
      'taskUUID': taskUUID,
      'model': model,
      'frameImages': [
        {'inputImage': dataUri, 'frame': 'first'},
      ],
      'positivePrompt': 'expression edit: $prompt',
      'duration': durationSeconds.toDouble(),
      'width': apiWidth,
      'height': apiHeight,
    };

    // Try direct inference endpoints first
    final directPaths = <String>[
      '/v1/video/inference',
      '/video/inference',
      '/v1/videoInference',
      '/videoInference',
      // AIR-scoped variants
      '/v1/air/video/inference',
      '/air/video/inference',
      '/v1/air/videoInference',
      '/air/videoInference',
    ];
    // Try minimal first
    for (final path in directPaths) {
      try {
        final url = await _postJson(path, bodyMinimal);
        if (url != null && url.isNotEmpty) return url;
      } catch (_) {}
    }
    // Then SDK-style
    for (final path in directPaths) {
      try {
        final url = await _postJson(path, bodySdk);
        if (url != null && url.isNotEmpty) return url;
      } catch (_) {}
    }

    // Try wrapper bodies (SDK often sends requestVideo: {...})
    final wrappedBodies = <Map<String, dynamic>>[
      {'requestVideo': bodyMinimal},
      {'requestVideo': bodySdk},
      {'video': bodyMinimal},
      {'video': bodySdk},
    ];
    for (final path in directPaths) {
      for (final wb in wrappedBodies) {
        try {
          final url = await _postJson(path, wb);
          if (url != null && url.isNotEmpty) return url;
        } catch (_) {}
      }
    }

    // Then task-based fallbacks
    final taskPaths = <String>[
      '/v1/tasks',
      '/tasks',
      '/v1/task',
      '/task',
      // AIR-scoped variants
      '/v1/air/tasks',
      '/air/tasks',
      '/v1/air/task',
      '/air/task',
    ];
    for (final path in taskPaths) {
      try {
        final url = await _postJson(path, bodyTaskMinimal);
        if (url != null && url.isNotEmpty) return url;
      } catch (_) {}
    }
    // Task with wrapper
    for (final path in taskPaths) {
      for (final wb in wrappedBodies) {
        try {
          final url = await _postJson(path, {
            'taskType': 'videoInference',
            ...wb,
          });
          if (url != null && url.isNotEmpty) return url;
        } catch (_) {}
      }
    }

    throw Exception('No valid Runware endpoint responded');
  }

  // Choose an allowed width/height for Seedance Pro Fast similar to the Python script
  (int, int) _pickCompatibleDimensions(
    int requestedW,
    int requestedH,
    String modelId,
  ) {
    if (!modelId.startsWith('bytedance:2@2')) {
      return (requestedW, requestedH);
    }
    final allowed = <(int, int)>[
      (864, 480), // 16:9
      (736, 544), // 4:3
      (640, 640), // 1:1
      (544, 736), // 3:4
      (480, 864), // 9:16
      (416, 960), // 9:21
      (960, 416), // 21:9
      (1920, 1088), // 16:9
      (1664, 1248), // 4:3
      (1440, 1440), // 1:1
      (1248, 1664), // 3:4
      (1088, 1920), // 9:16
      (928, 2176), // 9:21
      (2176, 928), // 21:9
    ];
    bool isSquare = requestedW == requestedH;
    bool isPortrait = requestedW < requestedH;
    String target;
    if (isSquare) {
      target = '1:1';
    } else if (isPortrait) {
      final r = requestedW / (requestedH == 0 ? 1 : requestedH);
      if ((r - 3 / 4).abs() < 0.05)
        target = '3:4';
      else if ((r - 9 / 16).abs() < 0.05)
        target = '9:16';
      else if ((r - 9 / 21).abs() < 0.05)
        target = '9:21';
      else
        target = '3:4';
    } else {
      final r = requestedW / (requestedH == 0 ? 1 : requestedH);
      if ((r - 16 / 9).abs() < 0.05)
        target = '16:9';
      else if ((r - 4 / 3).abs() < 0.05)
        target = '4:3';
      else if ((r - 21 / 9).abs() < 0.05)
        target = '21:9';
      else
        target = '16:9';
    }
    Iterable<(int, int)> candidates;
    switch (target) {
      case '1:1':
        candidates = allowed.where((e) => e.$1 == e.$2);
        break;
      case '3:4':
        candidates = allowed.where((e) => e.$1 * 4 == e.$2 * 3);
        break;
      case '4:3':
        candidates = allowed.where((e) => e.$1 * 3 == e.$2 * 4);
        break;
      case '9:16':
        candidates = allowed.where((e) => e.$1 * 16 == e.$2 * 9);
        break;
      case '16:9':
        candidates = allowed.where((e) => e.$1 * 9 == e.$2 * 16);
        break;
      case '9:21':
        candidates = allowed.where((e) => (e.$1 * 21 - e.$2 * 9) == 0);
        break;
      case '21:9':
        candidates = allowed.where((e) => (e.$1 * 9 - e.$2 * 21) == 0);
        break;
      default:
        candidates = const Iterable.empty();
    }
    final list = candidates.toList();
    if (list.isNotEmpty) {
      list.sort((a, b) => (a.$1 * a.$2).compareTo(b.$1 * b.$2));
      return list.first;
    }
    list.addAll(allowed);
    list.sort((a, b) => (a.$1 * a.$2).compareTo(b.$1 * b.$2));
    return list.first;
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

  String _guessMime(
    Uint8List bytes, {
    String fallback = 'application/octet-stream',
  }) {
    if (bytes.length >= 3) {
      // PNG
      if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E)
        return 'image/png';
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
          bytes[11] == 0x50)
        return 'image/webp';
    }
    return fallback;
  }

  static const String baseUrlSecond = 'https://api.runware.ai/v1';

  Future<Map<String, dynamic>> sendRequest(String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrlSecond),
        headers: {'Content-Type': 'application/json'},
        body: json.encode([
          {"taskType": "authentication", "apiKey": apiKey},
          {
            "taskType": "imageInference",
            "taskUUID": "39d7207a-87ef-4c93-8082-1431f9c1dc97",
            "positivePrompt": "smile",
            "seedImage":
                "http://res.cloudinary.com/drlpximxi/image/upload/v1757125972/o6rjrfjnhdvrdkeg6kct.jpg",
            "width": 512,
            "height": 512,
            "model": "SEED_EDIT_3_0",
            "numberResults": 1,
          },
        ]),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  //seed edit 3.0
  Future<void> generateAIAvatarWithPromptOption1() async {
    final String apiKey = RUNWARE_API_KEY;

    const String url = 'https://api.runware.ai/v1';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode([
          {
            "taskType": "imageInference",
            "numberResults": 1,
            "outputFormat": "PNG",
            "CFGScale": 5.5,
            "includeCost": true,
            "outputType": ["URL"],
            "referenceImages": [
              "http://res.cloudinary.com/drlpximxi/image/upload/v1757125972/o6rjrfjnhdvrdkeg6kct.jpg",
            ],
            "model": "bytedance:4@1",
            "positivePrompt": "smile",
            "taskUUID": "ec048145-143f-42b8-a335-e273a48e8a0c",
          },
        ]),
      );

      if (response.statusCode == 200) {
        // Success
        final responseData = json.decode(response.body);
        print('Success: $responseData');
      } else {
        // Error
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  final String apiRunwareKey = RUNWARE_API_KEY;
  final String baseUrlRunware = 'https://api.runware.ai/v1';

  Future<Map<String, dynamic>> generateAIEmotionVideoWithPrompt({
    required String inputImage,
    required String positivePrompt,
  }) async {
    final String taskUUID = const Uuid().v4();

    try {
      final response = await http.post(
        Uri.parse(baseUrlRunware),
        headers: {
          'Authorization': 'Bearer $apiRunwareKey',
          'Content-Type': 'application/json',
        },
        body: json.encode([
          {
            "taskType": "videoInference",
            "fps": 24,
            "model": "bytedance:2@2",
            "outputFormat": "mp4",
            "height": 480,
            "width": 864,
            "numberResults": 1,
            "includeCost": true,
            "outputQuality": 85,
            "providerSettings": {
              "bytedance": {"cameraFixed": false},
            },
            "frameImages": [
              {"inputImage": inputImage},
            ],
            "positivePrompt": positivePrompt,
            "taskUUID": taskUUID,
            "duration": 3,
          },
        ]),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response data: ${responseData}');

        return await _pollForResult(taskUUID);
      } else {
        throw Exception(
          'API request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to call Runware API: $e');
    }
  }

  Future<Map<String, dynamic>> _pollForResult(
    String taskUUID, {
    int maxRetries = 30,
    int retryDelaySeconds = 5,
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      print('Checking video status... (Attempt ${attempt + 1}/$maxRetries)');

      // Wait before checking
      await Future.delayed(Duration(seconds: retryDelaySeconds));

      try {
        final response = await http.post(
          Uri.parse(baseUrlRunware),
          headers: {
            'Authorization': 'Bearer $apiRunwareKey',
            'Content-Type': 'application/json',
          },
          body: json.encode([
            {"taskType": "getResponse", "taskUUID": taskUUID},
          ]),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final result = _handleGetResponse(responseData, taskUUID);

          if (result['status'] == 'success') {
            return result;
          } else if (result['status'] == 'processing') {
            continue; // Still processing, try again
          } else if (result['status'] == 'error') {
            throw Exception('Video generation failed: ${result['message']}');
          }
        } else {
          print('GetResponse failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error checking status: $e');
      }
    }

    throw Exception('Video generation timeout after $maxRetries attempts');
  }

  /// Generic poller that works for both image and video tasks, returning an `assetURL`
  /// which may be an `imageURL`, `videoURL`, or plain `url` depending on task type.
  Future<Map<String, dynamic>> _pollForResultGeneric(
    String taskUUID, {
    int maxRetries = 30,
    int retryDelaySeconds = 5,
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      print('Checking task status... (Attempt ${attempt + 1}/$maxRetries)');

      await Future.delayed(Duration(seconds: retryDelaySeconds));

      try {
        final response = await http.post(
          Uri.parse(baseUrlRunware),
          headers: {
            'Authorization': 'Bearer $apiRunwareKey',
            'Content-Type': 'application/json',
          },
          body: json.encode([
            {"taskType": "getResponse", "taskUUID": taskUUID},
          ]),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final result = _handleGetResponseGeneric(responseData, taskUUID);
          if (result['status'] == 'success') {
            return result;
          } else if (result['status'] == 'processing') {
            continue;
          } else if (result['status'] == 'error') {
            throw Exception('Task failed: ${result['message']}');
          }
        } else {
          print('GetResponse failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error checking status: $e');
      }
    }

    throw Exception('Task timeout after $maxRetries attempts');
  }

  Map<String, dynamic> _handleGetResponse(
    Map<String, dynamic> response,
    String expectedTaskUUID,
  ) {
    // Check for errors first
    if (response.containsKey('errors') && response['errors'] is List) {
      final errors = response['errors'] as List;
      if (errors.isNotEmpty) {
        // Find error for our specific task
        final taskError = errors.firstWhere(
          (error) => error['taskUUID'] == expectedTaskUUID,
          orElse: () => null,
        );

        if (taskError != null) {
          return {
            'status': 'error',
            'message': '${taskError['message']} (Code: ${taskError['code']})',
            'taskUUID': expectedTaskUUID,
          };
        }
      }
    }

    // Check for tasks in data array
    if (response.containsKey('data') && response['data'] is List) {
      final data = response['data'] as List;

      // Find our specific task
      final ourTask = data.firstWhere(
        (task) => task['taskUUID'] == expectedTaskUUID,
        orElse: () => null,
      );

      if (ourTask != null) {
        if (ourTask['status'] == 'success') {
          return {
            'status': 'success',
            'success': true,
            'taskUUID': ourTask['taskUUID'],
            'videoUUID': ourTask['videoUUID'],
            'videoURL': ourTask['videoURL'],
            'cost': ourTask['cost'],
            'rawResponse': response,
          };
        } else if (ourTask['status'] == 'processing') {
          return {
            'status': 'processing',
            'taskUUID': ourTask['taskUUID'],
            'message': 'Video is still being processed',
          };
        } else if (ourTask['status'] == 'error') {
          return {
            'status': 'error',
            'taskUUID': ourTask['taskUUID'],
            'message': 'Task failed with status: error',
          };
        }
      }
    }

    return {
      'status': 'error',
      'taskUUID': expectedTaskUUID,
      'message': 'Task not found in response',
    };
  }

  /// Generic handler for both images and videos.
  Map<String, dynamic> _handleGetResponseGeneric(
    Map<String, dynamic> response,
    String expectedTaskUUID,
  ) {
    if (response.containsKey('errors') && response['errors'] is List) {
      final errors = response['errors'] as List;
      if (errors.isNotEmpty) {
        final taskError = errors.firstWhere(
          (error) => error['taskUUID'] == expectedTaskUUID,
          orElse: () => null,
        );
        if (taskError != null) {
          return {
            'status': 'error',
            'message': '${taskError['message']} (Code: ${taskError['code']})',
            'taskUUID': expectedTaskUUID,
          };
        }
      }
    }

    if (response.containsKey('data') && response['data'] is List) {
      final data = response['data'] as List;
      final ourTask = data.firstWhere(
        (task) => task['taskUUID'] == expectedTaskUUID,
        orElse: () => null,
      );
      if (ourTask != null) {
        final status = ourTask['status'];
        if (status == 'success') {
          final assetURL =
              ourTask['videoURL'] ?? ourTask['imageURL'] ?? ourTask['url'];
          return {
            'status': 'success',
            'success': true,
            'taskUUID': ourTask['taskUUID'],
            'videoURL': ourTask['videoURL'],
            'imageURL': ourTask['imageURL'] ?? ourTask['url'],
            'assetURL': assetURL,
            'cost': ourTask['cost'],
            'rawResponse': response,
          };
        } else if (status == 'processing') {
          return {
            'status': 'processing',
            'taskUUID': ourTask['taskUUID'],
            'message': 'Task is still being processed',
          };
        } else if (status == 'error') {
          return {
            'status': 'error',
            'taskUUID': ourTask['taskUUID'],
            'message': 'Task failed with status: error',
          };
        }
      }
    }

    return {
      'status': 'error',
      'taskUUID': expectedTaskUUID,
      'message': 'Task not found in response',
    };
  }

  // ----- Avatar generation (SeedEdit 3.0 / Seedream 4.0) -----

  ({String model, String prompt, bool isSeedEdit}) _styleToModelPrompt(
    AvatarStyle style,
  ) {
    switch (style) {
      case AvatarStyle.seededit3d:
        return (model: 'bytedance:4@1', prompt: '3D', isSeedEdit: true);
      case AvatarStyle.seedream3d:
        return (model: 'bytedance:5@0', prompt: '3D', isSeedEdit: false);
      case AvatarStyle.seedreamAnime:
        return (model: 'bytedance:5@0', prompt: 'anime', isSeedEdit: false);
      case AvatarStyle.seedreamNeonGlow:
        return (model: 'bytedance:5@0', prompt: 'neon glow', isSeedEdit: false);
    }
  }

  /// Creates an avatar image from a selfie using Runware/ByteDance models.
  /// Provide `inputImage` as an HTTPS URL or data URI.
  Future<Map<String, dynamic>> generateAvatarFromImage({
    required String inputImage,
    required AvatarStyle style,
    int? width,
    int? height,
  }) async {
    final String taskUUID = const Uuid().v4();
    final cfg = _styleToModelPrompt(style);

    // Ensure reference image is a data URI (some providers don't fetch remote URLs).
    String referenceImage = inputImage;
    if (inputImage.startsWith('http')) {
      final bytes = await _downloadBytes(_forceHttps(inputImage));
      final mime = _guessMime(bytes, fallback: 'image/jpeg');
      referenceImage = 'data:$mime;base64,${base64Encode(bytes)}';
    }

    final Map<String, dynamic> body = {
      "taskType": "imageInference",
      "numberResults": 1,
      "outputFormat": "PNG",
      "includeCost": true,
      "outputType": ["URL"],
      "referenceImages": [
        referenceImage,
      ],
      "model": cfg.model,
      "positivePrompt": cfg.prompt,
      "taskUUID": taskUUID,
    };

    // SeedEdit 3.0 supports CFGScale and inherits aspect ratio from reference
    if (cfg.isSeedEdit) {
      body["CFGScale"] = 5.5;
    } else {
      // Seedream 4.0 supports explicit dimensions; default to 1024 if not set
      if (width != null && height != null) {
        body["width"] = width;
        body["height"] = height;
      } else {
        body["width"] = 1024;
        body["height"] = 1024;
      }
      body["providerSettings"] = {
        "bytedance": {"maxSequentialImages": 1}
      };
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrlRunware),
        headers: {
          'Authorization': 'Bearer $apiRunwareKey',
          'Content-Type': 'application/json',
        },
        body: json.encode([body]),
      );

      if (response.statusCode == 200) {
        // Try to return immediately if the API already provided a URL
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded['data'] is List) {
          final data = decoded['data'] as List;
          if (data.isNotEmpty) {
            final task = data.first;
            if (task is Map) {
              final url = task['imageURL'] ?? task['url'];
              if (url is String && url.isNotEmpty) {
                return {
                  'status': 'success',
                  'success': true,
                  'taskUUID': taskUUID,
                  'imageURL': url,
                  'assetURL': url,
                  'rawResponse': decoded,
                };
              }
            }
          }
        }
        // Otherwise poll until the image URL is ready
        return await _pollForResultGeneric(taskUUID);
      } else {
        throw Exception(
          'API request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to call Runware API (avatar): $e');
    }
  }

  /// Convenience flow: create avatar first, then generate video using that avatar
  /// as the input image for Seedance video.
  Future<Map<String, dynamic>> generateAvatarThenVideo({
    required String selfieImage,
    required AvatarStyle style,
    required String videoPrompt,
  }) async {
    final avatarResult =
        await generateAvatarFromImage(inputImage: selfieImage, style: style);
    final avatarUrl =
        avatarResult['assetURL'] ?? avatarResult['imageURL'] ?? avatarResult['url'];
    if (avatarUrl == null || (avatarUrl is String && avatarUrl.isEmpty)) {
      throw Exception('Avatar generation did not return an image URL');
    }

    // Reuse existing video function
    return await generateAIEmotionVideoWithPrompt(
      inputImage: avatarUrl as String,
      positivePrompt: videoPrompt,
    );
  }
}
