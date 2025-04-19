import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://52.79.80.204';

  static Future<Map<String, dynamic>?> searchUserById(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to search user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while searching user: $e');
    }
  }
} 