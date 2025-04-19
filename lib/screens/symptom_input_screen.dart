import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chat_screen.dart';
import '../widgets/body_part_selector.dart';

class SymptomInputScreen extends StatefulWidget {
  const SymptomInputScreen({super.key});

  @override
  State<SymptomInputScreen> createState() => _SymptomInputScreenState();
}

class _SymptomInputScreenState extends State<SymptomInputScreen> {
  Set<BodyPart> _selectedParts = {};
  Map<BodyPart, Offset> _selectedPositions = {}; // 각 부위별 선택된 위치 저장
  bool isOnboarding = true;
  bool showTouchAreas = false; // 터치 영역 표시 여부
  double touchAreaOpacity = 0.2; // 터치 영역 투명도

  // 로고 이미지 경로 상수
  static const String logoPath = 'assets/images/charactor/sick_patch.png';
  static const double logoSize = 20.0;

  // 터치 영역 크기 상수
  static const Map<BodyPart, Size> touchAreaSizes = {
    BodyPart.head: Size(190, 130),
    BodyPart.chest: Size(80, 40),
    BodyPart.abdomen: Size(90, 70),
    BodyPart.leftArm: Size(30, 80),
    BodyPart.rightArm: Size(80, 90),
    BodyPart.leftLeg: Size(70, 80),
    BodyPart.rightLeg: Size(70, 80),
  };

  // 터치 영역 위치 상수
  static const Map<BodyPart, Offset> touchAreaPositions = {
    BodyPart.head: Offset(0, 110),
    BodyPart.chest: Offset(0, 230),
    BodyPart.abdomen: Offset(0, 273),
    BodyPart.leftArm: Offset(-120, 230),
    BodyPart.rightArm: Offset(180, 220),
    BodyPart.leftLeg: Offset(-140, 300),
    BodyPart.rightLeg: Offset(150, 300),
  };

  void _onPartSelected(BodyPart part, Offset localPosition) {
    setState(() {
      if (_selectedParts.contains(part)) {
        _selectedParts.remove(part);
        _selectedPositions.remove(part);
      } else {
        _selectedParts.add(part);
        _selectedPositions[part] = localPosition;
      }
    });
  }

  void _onCompleteSelection() {
    if (_selectedParts.isEmpty) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          selectedBodyParts: _selectedParts,
          symptom: '',
          duration: '',
          painIntensity: 0.0,
        ),
      ),
    );
  }

  Widget _buildTouchArea(BodyPart part) {
    final size = touchAreaSizes[part]!;
    final position = touchAreaPositions[part]!;
    
    return Positioned(
      top: position.dy,
      left: position.dx < 0 ? MediaQuery.of(context).size.width / 2 + position.dx : null,
      right: position.dx > 0 ? MediaQuery.of(context).size.width / 2 - position.dx : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {
          final localPosition = details.localPosition;
          _onPartSelected(part, localPosition);
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: showTouchAreas ? Colors.blue.withOpacity(touchAreaOpacity) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              if (_selectedParts.contains(part))
                Positioned(
                  left: _selectedPositions[part]!.dx - logoSize / 2,
                  top: _selectedPositions[part]!.dy - logoSize / 2,
                  child: Image.asset(logoPath, width: logoSize, height: logoSize),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOnboarding) {
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              if (isOnboarding) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    const Text(
                      '헷갈리는 몸의 신호\n이젠 제가 도와드릴게요!',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Image.asset('assets/images/charactor/bubble/chat_onboarding_touch_bubble.png', width: 300),
                  ],
                ),
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/charactor/sick_medit.png',
                      height: 450,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                    ...BodyPart.values.where((part) => part != BodyPart.none).map((part) => _buildTouchArea(part)),
                  ],
                ),
              ),
              Text('아픈 부위를 여러 곳 선택할 수 있어요.',style: TextStyle(fontSize: 14)),
              SizedBox(height:20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onCompleteSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF394BF5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '선택 완료',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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