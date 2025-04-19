import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/body_part_selector.dart';

class ChatScreen extends StatefulWidget {
  final BodyPart selectedBodyPart;
  final String symptom;
  final String duration;
  final double painIntensity;

  const ChatScreen({
    super.key,
    required this.selectedBodyPart,
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addInitialMessages();
  }

  void _addInitialMessages() {
    String bodyPartName = _getBodyPartName(widget.selectedBodyPart);
    _messages.add(
      ChatMessage(
        text: '현재 ${bodyPartName}에 통증을 느끼시는군요.\n'
            '증상: ${widget.symptom}\n'
            '기간: ${widget.duration}\n'
            '통증 강도: ${widget.painIntensity.toStringAsFixed(1)}\n\n'
            '추가적인 증상이 있으신가요?',
        isUser: false,
        options: ['숨쉬기 힘듦', '어지러움', '두통', '없음'],
      ),
    );
    setState(() {});
  }

  String _getBodyPartName(BodyPart part) {
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
      case BodyPart.none:
        return '선택된 부위';
    }
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _messageController.clear();

    // 첫 번째 AI 응답
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: '말씀해 주신 증상으로 보아\n다음과 같은 질환을 의심해볼 수 있습니다:\n\n'
                '1. XX 증후군 (60%)\n'
                '2. YY 질환 (30%)\n'
                '3. ZZ 증상 (10%)\n\n'
                '정확한 진단을 위해 전문의 상담을 추천드립니다.',
            isUser: false,
          ),
        );
      });
    });

    // 두 번째 AI 응답
    Future.delayed(const Duration(milliseconds: 1600), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: '근처에 있는 전문병원을 찾아보시겠어요?',
            isUser: false,
            showMap: true,
            mapOptions: ['예', '아니요'],
          ),
        );
      });
    });

    // 스크롤을 맨 아래로 이동
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index].buildWidget();
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Text('Plus'),
            onPressed: () {
              // Plus 버튼 기능 구현
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: '메시지를 입력하세요',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          TextButton(
            onPressed: () => _handleSubmitted(_messageController.text),
            child: const Text(
              'send',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? options;
  final bool showMap;
  final List<String>? mapOptions;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.options,
    this.showMap = false,
    this.mapOptions,
  });

  Widget buildWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/images/charactor/medit_circle.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (options != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options!.map((option) {
                return OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
          if (showMap) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('관련 이미지'),
                  if (mapOptions != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: mapOptions!.map((option) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(option),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (showMap && mapOptions == null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {},
                child: const Text('리포트 요약하기'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
