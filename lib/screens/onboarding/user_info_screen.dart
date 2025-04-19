import 'package:flutter/material.dart';
import 'package:stdev2025_18team_frontend/constants/app_colors.dart';
import '../../models/user_info_model.dart';
import 'user_info2_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _nicknameController = TextEditingController();
  String? _selectedGender;
  String _selectedAge = '20대';
  int _characterCount = 0;

  final List<String> _ageGroups = [
    '10대 미만',
    '10대',
    '20대',
    '30대',
    '40대',
    '50대',
    '60대 이상',
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      setState(() {
        _characterCount = _nicknameController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _loginIdController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _saveUserInfo() async {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      final userInfo = UserInfoModel(
        loginId: _loginIdController.text,
        nickname: _nicknameController.text,
        gender: _selectedGender!,
        age: _selectedAge,
        symptoms: [],
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserInfo2Screen(userInfo: userInfo),
        ),
      );
    } else if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('성별을 선택해주세요'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 370,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/charactor/intro_medit.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 40, 18, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('아이디를 입력해주세요!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          controller: _loginIdController,
                          decoration: InputDecoration(
                            hintText: '아이디를 입력하세요',
                            hintStyle: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w700),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        if (_loginIdController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => _loginIdController.clear(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('닉네임을 정해주세요!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          controller: _nicknameController,
                          maxLength: 13,
                          decoration: InputDecoration(
                            hintText: '닉네임을 입력하세요',
                            hintStyle: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w700),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '닉네임을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        if (_nicknameController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => _nicknameController.clear(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('$_characterCount / 13', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                    const SizedBox(height: 30),
                    const Text('연령대가 어떻게 되시나요?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.thirdColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('이모지를 클릭하여 응답해 주세요!', style: TextStyle(fontSize: 11)),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 90,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Row(
                                  children: List.generate(_ageGroups.length - 1, (index) {
                                    return Expanded(
                                      child: Container(
                                        height: 2,
                                        color: AppColors.primary,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _ageGroups.map((age) {
                                  final isSelected = age == _selectedAge;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedAge = age),
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: AppColors.primary, width: 2),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              if (isSelected)
                                                Image.asset(
                                                  'assets/images/charactor/graph_medit.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            age,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? AppColors.primary : const Color(0xFF818283),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text('성별을 알려주세요!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedGender = '여자'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedGender == '여자' ? AppColors.thirdColor : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset('assets/images/charactor/woman.png', height: 160),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedGender = '남자'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedGender == '남자' ? AppColors.thirdColor : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset('assets/images/charactor/man.png', height: 160),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveUserInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('다음', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
