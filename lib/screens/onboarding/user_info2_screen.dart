import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_info_model.dart';
import '../home/home_screen.dart';
import '../../services/api_service.dart';
import '../../constants/app_colors.dart';
import 'dart:convert';

class UserInfo2Screen extends StatefulWidget {
  final UserInfoModel userInfo;

  const UserInfo2Screen({super.key, required this.userInfo});

  @override
  State<UserInfo2Screen> createState() => _UserInfo2ScreenState();
}

class _UserInfo2ScreenState extends State<UserInfo2Screen> {
  final List<String> _symptoms = [
    '심장 질환 ex) 협심증, 심부전 등',
    '뇌혈관 질환 ex) 뇌졸중 등',
    '호흡기 질환 ex) 천식, 만성폐쇄성폐질환 등',
    '간 질환 ex) 간염, 지방간, 간경화 등',
    '신장 질환 ex) 만성신부전, 투석 중',
    '정신 건강 질환 ex) 우울증, 불안장애 등',
    '알레르기 질환 ex) 음식 알레르기, 약물 알레르기 등',
    '고혈압',
    '당뇨병',
    '임신 또는 수유 중',
    '기타 (직접 입력)',
    '없음',
  ];

  final Set<String> _selectedSymptoms = {};
  final TextEditingController _customSymptomController = TextEditingController();
  bool _isCustomInputVisible = false;

  @override
  void dispose() {
    _customSymptomController.dispose();
    super.dispose();
  }

  void _showCustomInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('직접 입력'),
        content: TextField(
          controller: _customSymptomController,
          decoration: const InputDecoration(
            hintText: '질환을 입력해주세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (_customSymptomController.text.isNotEmpty) {
                setState(() {
                  _selectedSymptoms.add(_customSymptomController.text);
                  _isCustomInputVisible = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '평소 어떤 질환을 가지고 계신지 알려주시면\n맞춤형 도움을 드릴 수 있어요 :)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.thirdColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text: '복수응답',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    const TextSpan(
                      text: ' 여러개 선택이 가능해요',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _symptoms.length + (_isCustomInputVisible ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _symptoms.length && _isCustomInputVisible) {
                  return _buildSymptomTile(_customSymptomController.text, true, isCustom: true);
                }

                final symptom = _symptoms[index];
                final isSelected = _selectedSymptoms.contains(symptom);
                return _buildSymptomTile(symptom, isSelected);
              },
            ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveAllUserInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '저장하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomTile(String symptom, bool isSelected, {bool isCustom = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.thirdColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? null : Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        title: symptom.contains('ex)')
            ? RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: symptom.substring(0, symptom.indexOf('ex)')),
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              TextSpan(
                text: 'ex)',
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? AppColors.primary : Colors.black54,
                ),
              ),
              TextSpan(
                text: symptom.substring(symptom.indexOf('ex)') + 3),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppColors.primary : Colors.black54,
                ),
              ),
            ],
          ),
        )
            : Text(
          symptom,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        )
            : Icon(Icons.circle_outlined, color: Colors.grey[400]),
        onTap: () {
          setState(() {
            if (isCustom) {
              _selectedSymptoms.remove(symptom);
              _isCustomInputVisible = false;
              _customSymptomController.clear();
            } else if (symptom == '기타 (직접 입력)') {
              _showCustomInputDialog();
            } else if (symptom == '없음') {
              if (isSelected) {
                _selectedSymptoms.remove(symptom);
              } else {
                _selectedSymptoms.clear();
                _selectedSymptoms.add(symptom);
                _isCustomInputVisible = false;
                _customSymptomController.clear();
              }
            } else {
              if (isSelected) {
                _selectedSymptoms.remove(symptom);
              } else {
                _selectedSymptoms.remove('없음');
                _selectedSymptoms.add(symptom);
              }
            }
          });
        },
      ),
    );
  }

  Future<void> _saveAllUserInfo() async {
    final userInfo = UserInfoModel(
      loginId: widget.userInfo.loginId,
      nickname: widget.userInfo.nickname,
      gender: widget.userInfo.gender == '여자' ? '여' : '남',
      age: widget.userInfo.age,
      symptoms: _selectedSymptoms.toList(),
    );

    try {
      String ageRange = _convertAgeToRange(userInfo.age);
      final member = {
        'login_id': userInfo.loginId,
        'nickname': userInfo.nickname,
        'age_range': ageRange,
        'gender': userInfo.gender,
        'usual_illness': userInfo.symptoms,
      };

      await ApiService.registerUser(member);
      
      final prefs = await SharedPreferences.getInstance();
      final userData = {
        'loginId': userInfo.loginId,
        'nickname': userInfo.nickname,
        'gender': userInfo.gender,
        'age': userInfo.age,
        'ageRange': ageRange,
        'symptoms': userInfo.symptoms,
      };
      await prefs.setString('user_data', json.encode(userData));
      await prefs.setBool('isFirstTime', false);
      await prefs.setBool('is_onboarding_completed', true);
      await prefs.setString('login_id', userInfo.loginId);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
            duration: Duration(seconds: 2)
          ),
        );
      }
    }
  }

  String _convertAgeToRange(String age) {
    switch (age) {
      case '10대 미만':
        return '0-9';
      case '10대':
        return '10-19';
      case '20대':
        return '20-29';
      case '30대':
        return '30-39';
      case '40대':
        return '40-49';
      case '50대':
        return '50-59';
      case '60대 이상':
        return '60-99';
      default:
        return '20-29';
    }
  }
}
