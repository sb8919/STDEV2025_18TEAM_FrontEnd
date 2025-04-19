import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'http://52.79.80.204';

  // 대화 생성
  Future<Map<String, dynamic>> createConversation(String loginId, {String? title, String? messageContent}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$loginId/conversations/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          if (title != null) 'title': title,
          if (messageContent != null) 'message_content': messageContent,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Server response: ${response.body}');
        throw Exception('Failed to create conversation: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error creating conversation: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  // 대화 메시지 목록 조회
  Future<List<dynamic>> getMessages(String conversationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversations/$conversationId/messages/'),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Server response: ${response.body}');
        throw Exception('Failed to get messages: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error getting messages: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  // 사용자의 특정 대화에 메시지 추가
  Future<Map<String, dynamic>> sendMessageToUserConversation(
    String loginId,
    String conversationId,
    String content,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$loginId/conversations/$conversationId/messages/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(jsonEncode({
          'sender': 'user',
          'content': content,
        })),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        print('Server response decoded: $decodedResponse');
        return decodedResponse;
      } else {
        print('Error response: ${utf8.decode(response.bodyBytes)}');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Connection error: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Map<String, dynamic>> createConversationReport(
    String conversationId,
    Map<String, dynamic> reportData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/conversations/$conversationId/reports/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(jsonEncode(reportData)),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to create report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Map<String, dynamic>> getDiseaseReports(String loginId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$loginId/reports/diseases/'),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to get disease reports: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
} 