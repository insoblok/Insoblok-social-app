import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  /// Generic POST request
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
        logger.d("request is $url, $body");

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
}
