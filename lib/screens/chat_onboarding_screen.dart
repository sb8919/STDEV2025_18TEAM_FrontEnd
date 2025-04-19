import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/pain_intensity_slider.dart';
import '../widgets/body_part_selector.dart';
import '../widgets/text_input_field.dart';
import 'chat_screen.dart';

class ChatOnboardingScreen extends StatefulWidget {
  const ChatOnboardingScreen({super.key});

  @override
  State<ChatOnboardingScreen> createState() => _ChatOnboardingScreenState();
}

class _ChatOnboardingScreenState extends State<ChatOnboardingScreen> {
  double _painIntensity = 0.0;
  BodyPart _selectedBodyPart = BodyPart.none;
  final TextEditingController _symptomController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  void _startChat() {
    if (_selectedBodyPart == BodyPart.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아픈 부위를 선택해주세요')),
      );
      return;
    }

    if (_symptomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('증상을 입력해주세요')),
      );
      return;
    }

    if (_durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('증상 기간을 입력해주세요')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          selectedBodyPart: _selectedBodyPart,
          symptom: _symptomController.text,
          duration: _durationController.text,
          painIntensity: _painIntensity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '헷갈리는 몸의 신호\n이젠 제가 도와드릴게요!',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '어디가 아프신가요? 제가 도와드릴게요!',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BodyPartSelector(
                  onPartSelected: (part) {
                    setState(() {
                      _selectedBodyPart = part;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              TextInputField(
                question: '어떤 증상이 있으신가요?',
                label_hint: '증상을 자세히 설명해주세요',
                type_assist: '불편한 증상을 적어주시면 제가 도와드릴게요!',
                controller: _symptomController,
              ),
              const SizedBox(height: 60),
              TextInputField(
                question: '언제부터 이런증상이 있었나요?',
                label_hint: '증상 기간을 입력하세요',
                type_assist: '며칠 전부터 아프셨는지 알려주실 수 있으실까요?',
                controller: _durationController,
              ),
              const SizedBox(height: 60),
              PainIntensitySlider(
                title: '통증은 어느 정도로 느껴지시나요?',
                initialValue: _painIntensity,
                onChanged: (value) {
                  setState(() {
                    _painIntensity = value;
                  });
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _startChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005BAC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 