import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../widgets/pain_intensity_slider.dart';
import '../widgets/body_part_selector.dart';
import '../widgets/text_input_field.dart';
import 'chat_screen.dart';
import 'symptom_input_screen.dart';

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

  void _startSymptomInput() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SymptomInputScreen(),
      ),
    );
  }

  void _startDirectChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          selectedBodyParts: {BodyPart.none},
          symptom: '',
          duration: '',
          painIntensity: 0.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '안녕하세요!메딧이에요 :)\n아픈 곳이 있으신가요?',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Image.asset('assets/images/charactor/bubble/chat_onboarding_bubble.png', width: 300),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  Image.asset('assets/images/charactor/hello_medit.png', width: 280),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _startSymptomInput,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF394BF5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '네, 해주세요',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _startDirectChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF394BF5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '아니요, 직접질문할게요',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 