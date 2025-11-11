import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/logger_service.dart';

/// Minimal wrapper around Runware image-to-video API.
/// This is intentionally lenient on schema so it can evolve without breaking the app.
class RunwareService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.runware.ai', // keep configurable if needed
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 60),
    ),
  )..interceptors.add(LogInterceptor());

  RunwareService() {
    _dio.options.headers.addAll(<String, dynamic>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $RUNWARE_API_KEY',
    });
  }

  /// Create an image-to-video task.
  ///
  /// Returns a map with at least an 'id' or a final 'url' when available.
  /// The exact structure depends on Runware responses; we parse defensively.
  Future<Map<String, dynamic>> createImageToVideo({
    required String imageUrl,
    String? prompt,
    int durationSeconds = 4,
  }) async {
    try {
      // Some Runware deployments accept POST /v1/tasks with {type:'image-to-video', input:{...}}
      final payload = {
        'type': 'image-to-video',
        'input': {
          'image_url': imageUrl,
          if (prompt != null && prompt.isNotEmpty) 'prompt': prompt,
          'duration': durationSeconds,
        }
      };
      final res = await _dio.post('/v1/tasks', data: jsonEncode(payload));
      final data = _safeToMap(res.data);
      return data;
    } catch (e, s) {
      logger.e('Runware createImageToVideo failed', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Poll a task until completion or error.
  /// Returns the final task payload when status != 'running'.
  Future<Map<String, dynamic>> pollTask(String taskId) async {
    try {
      for (int i = 0; i < 120; i++) {
        final res = await _dio.get('/v1/tasks/$taskId');
        final data = _safeToMap(res.data);
        final status = (data['status'] ?? '').toString().toLowerCase();
        if (status != 'running' && status != 'queued' && status != 'processing') {
          return data;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
      throw Exception('Runware task polling timeout');
    } catch (e, s) {
      logger.e('Runware pollTask failed', error: e, stackTrace: s);
      rethrow;
    }
  }

  Map<String, dynamic> _safeToMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return {'data': v};
  }
}


