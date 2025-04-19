import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_info_model.dart';
import '../home/home_screen.dart';

class UserInfo2Screen extends StatefulWidget {
  final UserInfoModel userInfo;

  const UserInfo2Screen({super.key, required this.userInfo});

  @override
  State<UserInfo2Screen> createState() => _UserInfo2ScreenState();
}

class _UserInfo2ScreenState extends State<UserInfo2Screen> {
  final List<String> _symptoms = [
    '없음',
    '고혈압',
    '당뇨병',
    '심장 질환',
    '뇌혈관 질환',
    '호흡기 질환',
    '간 질환',
    '신장 질환',
    '정신 건강 질환',
    '알레르기 질환',
    '임신 또는 수유 중',
    '기타 (직접 입력)',
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
              decoration: const BoxDecoration(
                color: Color(0xFFD6D6D6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Text(
                '복수응답 어려게 선택이 가능해요',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
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
                  // 직접 입력한 항목 표시
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF005BAC),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        _customSymptomController.text,
                        style: const TextStyle(
                          color: Color(0xFF005BAC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.check_circle, color: Color(0xFF005BAC)),
                      onTap: () {
                        setState(() {
                          _selectedSymptoms.remove(_customSymptomController.text);
                          _isCustomInputVisible = false;
                          _customSymptomController.clear();
                        });
                      },
                    ),
                  );
                }

                final symptom = _symptoms[index];
                final isSelected = _selectedSymptoms.contains(symptom);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF005BAC) : Colors.grey[300]!,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      symptom,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF005BAC) : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Color(0xFF005BAC))
                        : Icon(Icons.circle_outlined, color: Colors.grey[400]),
                    onTap: () {
                      if (symptom == '기타 (직접 입력)') {
                        _showCustomInputDialog();
                      } else if (symptom == '없음') {
                        setState(() {
                          if (isSelected) {
                            _selectedSymptoms.remove(symptom);
                          } else {
                            _selectedSymptoms.clear();
                            _selectedSymptoms.add(symptom);
                            _isCustomInputVisible = false;
                            _customSymptomController.clear();
                          }
                        });
                      } else {
                        setState(() {
                          if (isSelected) {
                            _selectedSymptoms.remove(symptom);
                          } else {
                            if (_selectedSymptoms.contains('없음')) {
                              _selectedSymptoms.remove('없음');
                            }
                            _selectedSymptoms.add(symptom);
                          }
                        });
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveAllUserInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005BAC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAllUserInfo() async {
    final userInfo = UserInfoModel(
      nickname: widget.userInfo.nickname,
      gender: widget.userInfo.gender,
      age: widget.userInfo.age,
      symptoms: _selectedSymptoms.toList(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userInfo.nickname);
    await prefs.setString('gender', userInfo.gender);
    await prefs.setString('age', userInfo.age);
    await prefs.setStringList('symptoms', userInfo.symptoms);
    await prefs.setBool('isFirstTime', false);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
} 