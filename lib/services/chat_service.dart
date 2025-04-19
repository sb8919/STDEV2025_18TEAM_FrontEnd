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
      print('Sending message to user $loginId conversation $conversationId: $content');
      final response = await http.post(
        Uri.parse('$baseUrl/users/$loginId/conversations/$conversationId/messages/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'sender': 'user',
          'content': content,
        }),
      );

      print('Message response: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Server response: ${response.body}');
        throw Exception('Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }
} 