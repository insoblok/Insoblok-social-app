import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  /// Generic GET request
  Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('GET failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('GET Exception: $e');
    }
  }

  Future<dynamic> getRequestWithFullUrl(String endpoint) async {
    final url = Uri.parse(endpoint);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('GET failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('GET Exception: $e');
    }
  }

  /// Generic POST request
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('POST failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('POST Exception: $e');
    }
  }

  Future<dynamic> logRequest(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(telemetryBaseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $telemetryAPIKey", // Fixed typo: Authentication → Authorization
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30)); // Add timeout

      if (response.statusCode == 200 || response.statusCode == 202) {
        logger.d("Response is ${response.statusCode}");
        return jsonDecode(response.body);
      } else {
        // More detailed error handling
        throw HttpException(
          'HTTP ${response.statusCode}',
          uri: Uri.parse(telemetryBaseUrl),
        );
      }
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
