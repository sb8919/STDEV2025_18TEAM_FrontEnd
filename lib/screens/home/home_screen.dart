import 'package:flutter/material.dart';
import '../calendar_screen.dart';
import '../chat_onboarding_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/member.dart';
import '../../models/card_news.dart';
import 'components/week_calendar.dart';
import 'components/home_app_bar.dart';
import 'components/default_app_bar.dart';
import 'components/home_bottom_navigation_bar.dart';
import 'components/acquaintance_section.dart';
import 'components/add_acquaintance_dialog.dart';
import 'components/profile_section.dart';
import 'components/news_card.dart';

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
      acquaintances: [
        Acquaintance(
          name: '구성원 1',
          relationship: '모',
          imagePath: 'assets/images/charactor/medit_circle.png',
          healthMetrics: HealthMetrics(
            metrics: [
              MetricData(name: '편두통', value: 0.8, severityLevel: 3),
              MetricData(name: '건강상태', value: 0.6, severityLevel: 2),
              MetricData(name: '복통', value: 0.4, severityLevel: 1),
            ],
          ),
        ),
        Acquaintance(
          name: '구성원 2',
          relationship: '부',
          imagePath: 'assets/images/charactor/medit_circle.png',
          healthMetrics: HealthMetrics(
            metrics: [
              MetricData(name: '불안감', value: 0.9, severityLevel: 3),
              MetricData(name: '현기', value: 0.7, severityLevel: 2),
              MetricData(name: '걱정', value: 0.5, severityLevel: 1),
            ],
          ),
        ),
        Acquaintance(
          name: '구성원 3',
          relationship: '배우자',
          imagePath: 'assets/images/charactor/medit_circle.png',
          healthMetrics: HealthMetrics(
            metrics: [
              MetricData(name: '근육통', value: 0.7, severityLevel: 3),
              MetricData(name: '두통', value: 0.5, severityLevel: 2),
              MetricData(name: '손저림', value: 0.3, severityLevel: 1),
            ],
          ),
        ),
      ],
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

  // 차트 관련 상수
  final double barMaxHeight = 80.0;
  final double barWidth = 24.0;

  // Sample news data
  final List<CardNews> newsList = [
    CardNews(
      title: "술마시고 두통, 타이레놀 먹어도 될까요?",
      iconPath: "assets/images/logos/logo.png",
      date: "2024.03.20",
    ),
    CardNews(
      title: "헷갈리는 감기 vs 독감 차이 3초만에 확인하기",
      iconPath: "assets/images/logos/logo.png",
      date: "2024.03.20",
    ),
    CardNews(
      title: "이 증상 알고 보니 코로나일 수 있다?",
      iconPath: "assets/images/logos/logo.png",
      date: "2024.03.20",
    ),
  ];

  Color _getSeverityColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF91D7E0); // 연한 청록색
      case 2:
        return const Color(0xFFFF9E9E); // 연한 주황색
      case 3:
        return const Color(0xFFFF6B6B); // 진한 주황색
      default:
        return Colors.grey;
    }
  }

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

  void _showAddAcquaintanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAcquaintanceDialog(
        onAdd: (newAcquaintance) {
          setState(() {
            final mainMemberIndex = _members.indexWhere((member) => member.isMainProfile);
            if (mainMemberIndex != -1) {
              final mainMember = _members[mainMemberIndex];
              if (mainMember.acquaintances.length < 4) {
                _members[mainMemberIndex] = Member(
                  nickname: mainMember.nickname,
                  gender: mainMember.gender,
                  age: mainMember.age,
                  symptoms: mainMember.symptoms,
                  relationship: mainMember.relationship,
                  isMainProfile: mainMember.isMainProfile,
                  acquaintances: [...mainMember.acquaintances, newAcquaintance],
                );
              }
            }
          });
        },
      ),
    );
  }

  void _showNewsDetailModal(BuildContext context, CardNews news) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  news.iconPath,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "자세한 가능성이 높아져 같이 병원을 위험!\n술 마시기 전후, 당일의 복용 금지를 추천해 드리요!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "대체 약으로는 이부프로펜 계열로 복용해, 현재 등을 추천해요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF666666),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "확인했어요!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildHealthStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/charactor/medit_circle.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '건강 상태',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '최근 7일 기준',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF868686),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricBar('두통', 0.7, 2),
              _buildMetricBar('어지러움', 0.5, 1),
              _buildMetricBar('스트레스', 0.3, 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar(String label, double value, int severityLevel) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 24,
              height: 80 * value,
              decoration: BoxDecoration(
                color: _getSeverityColor(severityLevel),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 32,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF868686),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _bottomNavIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileSection(
                      members: _members,
                      selectedMember: _selectedMember,
                      isExpanded: _isExpanded,
                      onMemberUpdate: _handleMemberUpdate,
                      onToggleMemberDetail: _toggleMemberDetail,
                      onToggleExpanded: _toggleExpanded,
                      onAddProfile: _showAddProfileDialog,
                    ),
                    AcquaintanceSection(
                      mainMember: _members.firstWhere((member) => member.isMainProfile),
                      onAddTap: _showAddAcquaintanceDialog,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      '${_nickname}님, 요즘 궁금할 만한 것들을 알려드릴게요!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...newsList.map((news) => GestureDetector(
                      onTap: () => _showNewsDetailModal(context, news),
                      child: NewsCard(news: news),
                    )).toList(),
                  ],
                ),
              ),
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