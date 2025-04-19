import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stdev2025_18team_frontend/constants/app_colors.dart';
import '../services/chat_service.dart';
import '../widgets/body_part_selector.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final Set<BodyPart> selectedBodyParts;
  final String symptom;
  final String duration;
  final double painIntensity;

  const ChatScreen({
    super.key,
    required this.selectedBodyParts,
    required this.symptom,
    required this.duration,
    required this.painIntensity,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  bool _isLoading = false;
  String? _conversationId;
  String? _userId;
  String? _loginId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  String _bodyPartToKorean() {
    return widget.selectedBodyParts.map((part) {
      switch (part) {
        case BodyPart.head:
          return '머리';
        case BodyPart.body:
          return '몸통';
        case BodyPart.leftArm:
          return '왼팔';
        case BodyPart.rightArm:
          return '오른팔';
        case BodyPart.leftLeg:
          return '왼다리';
        case BodyPart.rightLeg:
          return '오른다리';
        default:
          return '';
      }
    }).join(', ');
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _loginId = prefs.getString('login_id');
    
    print('Loaded login ID: $_loginId');
    
    if (_loginId == null) {
      _addBotMessage('로그인이 필요합니다. 로그인 후 다시 시도해주세요.');
      return;
    }
    
    _initializeConversation();
  }

  Future<void> _initializeConversation() async {
    if (_loginId == null) return;
    
    setState(() => _isLoading = true);
    try {
      final initialMessage = '${_bodyPartToKorean()} 부위에 ${widget.symptom} 증상이 ${widget.duration} 동안 ${widget.painIntensity.toStringAsFixed(1)} 강도로 느껴졌군요.\n무엇이 궁금하신가요?';
      
      print('Creating conversation with login ID: $_loginId');
      final response = await _chatService.createConversation(_loginId!, messageContent: initialMessage);
      print('Conversation created: $response');
      
      _conversationId = response['id'];
      _userId = response['user_id'];
      
      // AI의 첫 메시지 표시
      if (response['conversation_message'] != null) {
        final aiMessage = response['conversation_message'];
        _addBotMessage(aiMessage['content']);
      }
    } catch (e) {
      print('Error in _initializeConversation: $e');
      _addBotMessage('죄송합니다. 서버와의 연결에 문제가 발생했습니다.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: false));
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _conversationId == null || _loginId == null) return;

    _addUserMessage(text);
    _messageController.clear();

    setState(() => _isLoading = true);

    try {
      final response = await _chatService.sendMessageToUserConversation(
        _loginId!,
        _conversationId!,
        text,
      );
      
      if (response['conversation_message'] != null) {
        _addBotMessage(response['conversation_message']['content']);
      }
    } catch (e) {
      print('Error sending message: $e');
      _addBotMessage('죄송합니다. 메시지 전송에 실패했습니다.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateString =
        '${today.year}년 ${today.month}월 ${today.day}일 ${["일", "월", "화", "수", "목", "금", "토"][today.weekday % 7]}요일';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '메딧톡',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: const SizedBox(),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 날짜 표시
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      dateString,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),

            // 채팅 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index].buildWidget(),
              ),
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('조금만 기다려주세요...', style: TextStyle(color: Colors.grey)),
              ),

            // 입력창
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  // + 버튼
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon/plus.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // TODO: 추가 기능 구현
                    },
                  ),
                  // 입력 필드
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: '메시지를 입력하세요',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  // 마이크 버튼
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon/mic.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // TODO: 음성 입력 기능 구현
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  Widget buildWidget() {
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.zero,
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 80,top:20 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/charactor/medit_circle.png',
                    width: 46,
                    height: 46,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '메딧톡',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // 메시지 말풍선
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(left: 0), // 왼쪽 마진 제거
              constraints: const BoxConstraints(maxWidth: 270), // 최대 너비 설정
              decoration: BoxDecoration(
                color: const Color(0xFFC3CCF5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    }
  }
}
