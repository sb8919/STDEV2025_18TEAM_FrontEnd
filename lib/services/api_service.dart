import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/member.dart';

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

  static Future<Map<String, dynamic>?> registerUser(Map<String, dynamic> userData) async {
    try {
      print('Sending registration request to: $baseUrl/users/');
      print('Request data: ${json.encode(userData)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/users/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Successfully registered user: $responseData');
        return responseData;
      } else {
        print('Registration failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during registration: $e');
      print('Stack trace: ${StackTrace.current}');
      return null;
    }
  }
} 