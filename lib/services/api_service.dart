import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/member.dart';
import '../models/report.dart';

class ApiService {
  static const String baseUrl = 'http://52.79.80.204';

  static void _logRequest(String method, String url, [Map<String, dynamic>? body]) {
    print('\n=== API Request ===');
    print('Method: $method');
    print('URL: $url');
    if (body != null) {
      print('Body: ${jsonEncode(body)}');
    }
    print('==================\n');
  }

  static void _logResponse(int statusCode, String body) {
    print('\n=== API Response ===');
    print('Status Code: $statusCode');
    print('Body: $body');
    print('===================\n');
  }

  static Future<Map<String, dynamic>> searchUserById(String loginId) async {
    try {
      final url = '$baseUrl/users/$loginId';
      _logRequest('GET', url);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      _logResponse(response.statusCode, decodedBody);

      if (response.statusCode == 200) {
        return jsonDecode(decodedBody) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to search user: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('\n=== API Error ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('================\n');
      rethrow;
    }
  }

  static Future<List<Report>> getReports(String loginId) async {
    try {
      final url = '$baseUrl/users/$loginId/reports/';
      _logRequest('GET', url);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      _logResponse(response.statusCode, decodedBody);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(decodedBody) as List<dynamic>;
        final reports = jsonList.map((json) => Report.fromJson(json)).toList();
        
        print('\n=== Reports Data ===');
        print('Number of reports: ${reports.length}');
        if (reports.isNotEmpty) {
          print('First report:');
          print('Title: ${reports.first.title}');
          print('Summary: ${reports.first.summary}');
          print('Detected symptoms: ${reports.first.detectedSymptoms.join(', ')}');
          print('Diseases:');
          reports.first.diseasesWithProbabilities.forEach((disease) {
            print('  - ${disease.name}: ${disease.probability}');
          });
        }
        print('===================\n');
        
        return reports;
      } else {
        throw Exception('Failed to get reports: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('\n=== API Error ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('================\n');
      rethrow;
    }
  }

  static Future<void> registerUser(Map<String, dynamic> userData) async {
    try {
      final url = '$baseUrl/users';
      _logRequest('POST', url, userData);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      _logResponse(response.statusCode, decodedBody);

      if (response.statusCode != 201) {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('\n=== API Error ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('================\n');
      rethrow;
    }
  }
} 