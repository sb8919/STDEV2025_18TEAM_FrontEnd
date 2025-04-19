import 'package:flutter/material.dart';
import '../calendar_screen.dart';
import '../chat_onboarding_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/member.dart';
import 'components/week_calendar.dart';
import 'components/profile_card.dart';
import 'components/home_app_bar.dart';
import 'components/default_app_bar.dart';
import 'components/home_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  String _nickname = '';
  late DateTime _selectedDate;
  late DateTime _startOfWeek;
  bool _isExpanded = false;
  Member? _selectedMember;

  // 프로필 추가를 위한 컨트롤러들
  final TextEditingController _newNicknameController = TextEditingController();
  final TextEditingController _newGenderController = TextEditingController();
  final TextEditingController _newAgeController = TextEditingController();
  final TextEditingController _newSymptomsController = TextEditingController();
  bool _isNewProfileMain = false;

  final List<String> _weekDays = ['일', '월', '화', '수', '목', '금', '토'];
  final List<Widget> _bottomScreens = [
    const HomeScreen(),
    const CalendarScreen(),
    const ChatOnboardingScreen(),
  ];

  // 임시 데이터
  final List<Member> _members = [
    Member(
      nickname: '닉네임',
      gender: '여',
      age: 25,
      symptoms: ['두통', '어지러움'],
      relationship: '본인',
      isMainProfile: true,
    ),
    Member(
      nickname: '프로필 2',
      gender: '여',
      age: 11,
      symptoms: ['두통', '생리통'],
      relationship: '미성년 자녀',
      isMainProfile: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMainUserNickname();
    _selectedDate = DateTime.now();
    _startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday));
  }

  @override
  void dispose() {
    _newNicknameController.dispose();
    _newGenderController.dispose();
    _newAgeController.dispose();
    _newSymptomsController.dispose();
    super.dispose();
  }

  void _loadMainUserNickname() {
    final mainUser = _members.firstWhere(
      (member) => member.isMainProfile,
      orElse: () => _members.first,
    );
    setState(() {
      _nickname = mainUser.nickname;
    });
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      if (date.difference(_startOfWeek).inDays >= 7 || date.difference(_startOfWeek).inDays < 0) {
        _startOfWeek = date.subtract(Duration(days: date.weekday));
      }
      _selectedDate = date;
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        _selectedMember = null;
      }
    });
  }

  void _toggleMemberDetail(Member member) {
    setState(() {
      if (_selectedMember == member) {
        _selectedMember = null;
      } else {
        _selectedMember = member;
      }
    });
  }

  void _showAddProfileDialog() {
    // 컨트롤러 초기화
    _newNicknameController.clear();
    _newGenderController.clear();
    _newAgeController.clear();
    _newSymptomsController.clear();
    _isNewProfileMain = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: const Text(
              '프로필 추가',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _newNicknameController,
                    decoration: const InputDecoration(
                      labelText: '닉네임',
                      hintText: '닉네임을 입력하세요',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newGenderController,
                    decoration: const InputDecoration(
                      labelText: '성별',
                      hintText: '성별을 입력하세요',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newAgeController,
                    decoration: const InputDecoration(
                      labelText: '나이',
                      hintText: '나이를 입력하세요',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newSymptomsController,
                    decoration: const InputDecoration(
                      labelText: '평소 질환',
                      hintText: '콤마(,)로 구분하여 입력하세요',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('대표계정으로 설정'),
                      const SizedBox(width: 8),
                      Switch(
                        value: _isNewProfileMain,
                        onChanged: (value) {
                          setDialogState(() {
                            _isNewProfileMain = value;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_newNicknameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('닉네임을 입력해주세요.'),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    // 새 프로필이 대표계정으로 설정되는 경우, 기존 대표계정 해제
                    if (_isNewProfileMain) {
                      for (int i = 0; i < _members.length; i++) {
                        _members[i] = _members[i].copyWith(isMainProfile: false);
                      }
                    }

                    // 새 프로필 추가
                    final newMember = Member(
                      nickname: _newNicknameController.text,
                      gender: _newGenderController.text,
                      age: int.tryParse(_newAgeController.text) ?? 0,
                      symptoms: _newSymptomsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                      relationship: '가족',
                      isMainProfile: _isNewProfileMain,
                    );
                    
                    _members.add(newMember);

                    // 대표계정이 없는 경우 첫 번째 프로필을 대표계정으로 설정
                    if (!_members.any((member) => member.isMainProfile)) {
                      _members[0] = _members[0].copyWith(isMainProfile: true);
                    }

                    _loadMainUserNickname();
                  });

                  Navigator.of(context).pop();
                },
                child: Text(
                  '추가',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleMemberUpdate(Member updatedMember) {
    setState(() {
      final index = _members.indexWhere((m) => m.relationship == updatedMember.relationship);
      if (index != -1) {
        // 대표계정으로 설정되는 경우, 다른 프로필의 대표계정 설정 해제
        if (updatedMember.isMainProfile) {
          for (int i = 0; i < _members.length; i++) {
            if (i != index) {
              _members[i] = _members[i].copyWith(isMainProfile: false);
            }
          }
        }
        
        _members[index] = updatedMember;

        // 대표계정이 없는 경우 첫 번째 프로필을 대표계정으로 설정
        if (!_members.any((member) => member.isMainProfile)) {
          _members[0] = _members[0].copyWith(isMainProfile: true);
        }

        _loadMainUserNickname();
      }
    });
  }

  Widget _buildProfileSection() {
    final mainProfile = _members.firstWhere((member) => member.isMainProfile);
    final otherProfiles = _members.where((member) => !member.isMainProfile).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: !_isExpanded
                    ? BorderRadius.circular(15)
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
              ),
              child: ProfileCard(
                member: mainProfile,
                isExpanded: _selectedMember == mainProfile,
                onToggle: () => _toggleMemberDetail(mainProfile),
                showAllProfiles: _isExpanded,
                onShowAllToggle: _toggleExpanded,
                onMemberUpdate: _handleMemberUpdate,
              ),
            ),
            if (_isExpanded) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: Colors.grey),
              ),
              ...otherProfiles.map((member) => Column(
                children: [
                  ProfileCard(
                    member: member,
                    isExpanded: _selectedMember == member,
                    onToggle: () => _toggleMemberDetail(member),
                    showAllProfiles: _isExpanded,
                    onShowAllToggle: _toggleExpanded,
                    onMemberUpdate: _handleMemberUpdate,
                  ),
                  if (member != otherProfiles.last)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Colors.grey),
                    ),
                ],
              )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: Colors.grey),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showAddProfileDialog,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '프로필 추가하기',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Colors.grey),
            ),
            if (_members.length > 1)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: GestureDetector(
                  onTap: _toggleExpanded,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_bottomNavIndex == 0) {
      return HomeAppBar(
        nickname: _nickname,
        selectedDate: _selectedDate,
        startOfWeek: _startOfWeek,
        weekDays: _weekDays,
        onDateSelected: _handleDateSelected,
      ) as PreferredSizeWidget;
    }
    return const DefaultAppBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: _buildAppBar(),
      body: _bottomNavIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildProfileSection(),
            )
          : _bottomScreens[_bottomNavIndex],
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
} 