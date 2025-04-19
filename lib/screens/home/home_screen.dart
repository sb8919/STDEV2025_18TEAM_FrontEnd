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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../repositories/acquaintance_repository.dart';
import 'components/profile_section.dart';

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
  final _acquaintanceRepository = AcquaintanceRepository();

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
    const Scaffold(
      body: ChatOnboardingScreen(),
    ),
  ];

  // 임시 데이터
  List<Member> _members = [
    // Member(
    //   nickname: '닉네임',
    //   gender: '여',
    //   age: 25,
    //   symptoms: ['두통', '어지러움'],
    //   relationship: '본인',
    //   isMainProfile: true,
    //   loginId: 'user1',
    //   password: 'password1',
    //   ageRange: '20-29',
    //   acquaintances: [
    //     Acquaintance(
    //       name: '구성원 1',
    //       relationship: '모',
    //       imagePath: 'assets/images/charactor/medit_circle.png',
    //       healthMetrics: HealthMetrics(
    //         metrics: [
    //           MetricData(name: '편두통', value: 0.8, severityLevel: 3),
    //           MetricData(name: '건강상태', value: 0.6, severityLevel: 2),
    //           MetricData(name: '복통', value: 0.4, severityLevel: 1),
    //         ],
    //       ),
    //     ),
    //     Acquaintance(
    //       name: '구성원 2',
    //       relationship: '부',
    //       imagePath: 'assets/images/charactor/medit_circle.png',
    //       healthMetrics: HealthMetrics(
    //         metrics: [
    //           MetricData(name: '불안감', value: 0.9, severityLevel: 3),
    //           MetricData(name: '현기', value: 0.7, severityLevel: 2),
    //           MetricData(name: '걱정', value: 0.5, severityLevel: 1),
    //         ],
    //       ),
    //     ),
    //     Acquaintance(
    //       name: '구성원 3',
    //       relationship: '배우자',
    //       imagePath: 'assets/images/charactor/medit_circle.png',
    //       healthMetrics: HealthMetrics(
    //         metrics: [
    //           MetricData(name: '근육통', value: 0.7, severityLevel: 3),
    //           MetricData(name: '두통', value: 0.5, severityLevel: 2),
    //           MetricData(name: '손저림', value: 0.3, severityLevel: 1),
    //         ],
    //       ),
    //     ),
    //   ],
    //   healthMetrics: HealthMetrics(
    //     metrics: [
    //       MetricData(name: '건강상태', value: 0.7, severityLevel: 2),
    //     ],
    //   ),
    // ),
    // Member(
    //   nickname: '프로필 2',
    //   gender: '여',
    //   age: 11,
    //   symptoms: ['두통', '생리통'],
    //   relationship: '미성년 자녀',
    //   isMainProfile: false,
    //   loginId: 'user2',
    //   password: 'password2',
    //   ageRange: '10-19',
    //   acquaintances: [],
    //   healthMetrics: HealthMetrics(metrics: []),
    // ),
  ];

  // 차트 관련 상수
  final double barMaxHeight = 80.0;
  final double barWidth = 24.0;

  // Sample news data
  final List<CardNews> newsList = [
    CardNews(
      title: "술마시고 두통, 타이레놀 먹어도 될까요?",
      iconPath: "assets/images/icon/beer.png",
      date: "2024.03.20",
    ),
    CardNews(
      title: "헷갈리는 감기 vs 독감 차이 3초만에 확인하기",
      iconPath: "assets/images/icon/Cheers.png",
      date: "2024.03.20",
    ),
    CardNews(
      title: "이 증상 알고 보니 코로나일 수 있다?",
      iconPath: "assets/images/icon/Research.png",
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
    _loadUserInfo();
    _selectedDate = DateTime.now();
    _startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday));
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted = prefs.getBool('is_onboarding_completed') ?? false;
    
    if (isOnboardingCompleted) {
      try {
        final userDataString = prefs.getString('user_data');
        if (userDataString != null) {
          final userData = jsonDecode(userDataString);
          
          setState(() {
            _nickname = userData['nickname'] ?? '';
            
            // 등록된 사용자가 이미 멤버 리스트에 있는지 확인
            final existingMemberIndex = _members.indexWhere(
              (member) => member.loginId == userData['loginId']
            );
            
            if (existingMemberIndex == -1) {
              // 등록된 사용자가 없으면 새로 추가
              _members.insert(0, Member(
                nickname: userData['nickname'] ?? '',
                gender: userData['gender'] ?? '여',
                age: int.tryParse(userData['ageRange']?.split('-')[0] ?? '0') ?? 0,
                symptoms: List<String>.from(userData['symptoms'] ?? []),
                relationship: '본인',
                isMainProfile: true,
                loginId: userData['loginId'] ?? '',
                password: 'defaultPassword123',
                ageRange: userData['ageRange'] ?? '20-29',
                acquaintances: [],
                healthMetrics: HealthMetrics(
                  metrics: [
                    MetricData(
                      name: '건강상태',
                      value: 0.7,
                      severityLevel: 2,
                    ),
                  ],
                ),
              ));
              
              // 기존 멤버들의 isMainProfile을 false로 설정
              for (int i = 1; i < _members.length; i++) {
                _members[i] = _members[i].copyWith(isMainProfile: false);
              }
            } else {
              // 등록된 사용자가 이미 있으면 정보 업데이트
              _members[existingMemberIndex] = _members[existingMemberIndex].copyWith(
                nickname: userData['nickname'] ?? '',
                gender: userData['gender'] ?? '여',
                age: int.tryParse(userData['ageRange']?.split('-')[0] ?? '0') ?? 0,
                symptoms: List<String>.from(userData['symptoms'] ?? []),
                isMainProfile: true,
                ageRange: userData['ageRange'] ?? '20-29',
              );
              
              // 다른 멤버들의 isMainProfile을 false로 설정
              for (int i = 0; i < _members.length; i++) {
                if (i != existingMemberIndex) {
                  _members[i] = _members[i].copyWith(isMainProfile: false);
                }
              }
            }
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사용자 정보를 불러오는데 실패했습니다: $e')),
          );
        }
      }
    } else {
      // 온보딩이 완료되지 않은 경우 온보딩 화면으로 이동
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatOnboardingScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _newNicknameController.dispose();
    _newGenderController.dispose();
    _newAgeController.dispose();
    _newSymptomsController.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      if (date.difference(_startOfWeek).inDays >= 7 || date.isBefore(_startOfWeek)) {
        _startOfWeek = date.subtract(Duration(days: date.weekday % 7));
      }
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


  void _handleMemberUpdate(Member updatedMember) {
    setState(() {
      final index = _members.indexWhere((m) => m.loginId == updatedMember.loginId);
      if (index != -1) {
        if (updatedMember.isMainProfile) {
          for (int i = 0; i < _members.length; i++) {
            if (i != index) {
              _members[i] = _members[i].copyWith(isMainProfile: false);
            }
          }
        }

        _members[index] = updatedMember;

        if (!_members.any((member) => member.isMainProfile)) {
          _members[0] = _members[0].copyWith(isMainProfile: true);
        }
      } else {
        // 새 멤버 추가
        _members.add(updatedMember);
      }
    });
  }

  void _handleAddAcquaintance(Map<String, dynamic> userData) {
    final newAcquaintance = Acquaintance(
      name: userData['nickname'] ?? '',
      relationship: userData['relationship'] ?? '지인',
      imagePath: 'assets/images/charactor/medit_circle.png',
      age: userData['age'] ?? 25,
      gender: userData['gender'] ?? '남',
      healthMetrics: HealthMetrics(
        metrics: [
          MetricData(
            name: '건강상태',
            value: 0.7,
            severityLevel: 2,
          ),
        ],
      ),
    );

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
            healthMetrics: mainMember.healthMetrics,
            loginId: mainMember.loginId,
            password: mainMember.password,
            ageRange: mainMember.ageRange,
          );
        }
      }
    });
  }

  void _handleInfoUpdate(Acquaintance acquaintance, String name, String relationship) async {
    try {
      final updatedAcquaintance = acquaintance.copyWith(
        name: name,
        relationship: relationship,
      );
      
      await _acquaintanceRepository.updateAcquaintance(updatedAcquaintance);
      
      setState(() {
        final mainMemberIndex = _members.indexWhere((member) => member.isMainProfile);
        if (mainMemberIndex != -1) {
          final mainMember = _members[mainMemberIndex];
          final updatedAcquaintances = mainMember.acquaintances.map((a) {
            if (a.name == acquaintance.name) {
              return updatedAcquaintance;
            }
            return a;
          }).toList();
          
          _members[mainMemberIndex] = mainMember.copyWith(
            acquaintances: updatedAcquaintances,
          );
        }
      });
    } catch (e) {
      print('Error updating acquaintance info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지인 정보 업데이트에 실패했습니다.')),
      );
    }
  }

  void _handleAcquaintanceDelete(Acquaintance acquaintance) {
    setState(() {
      final mainMemberIndex = _members.indexWhere((member) => member.isMainProfile);
      if (mainMemberIndex != -1) {
        final mainMember = _members[mainMemberIndex];
        final updatedAcquaintances = List<Acquaintance>.from(mainMember.acquaintances)
          ..removeWhere((a) => a.name == acquaintance.name);
        
        _members[mainMemberIndex] = mainMember.copyWith(
          acquaintances: updatedAcquaintances,
        );
      }
    });
  }

  void _showNewsDetailModal(BuildContext context, CardNews news) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD0D6F5),  // 더 진한 블루
                    Color(0xFFE8ECFD),
                    Color(0xFFFFFFFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "자세한 가능성이 높아져 같이 병원을 위험!\n술 마시기 전후, 당일의 복용 금지를 추천해 드리요!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
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
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadMainMember() async {
    try {
      final mainMember = _members.firstWhere(
        (member) => member.isMainProfile,
        orElse: () => _members.first,
      );
      
      final updatedAcquaintances = await _acquaintanceRepository.getAcquaintances(mainMember.loginId);
      
      setState(() {
        final mainMemberIndex = _members.indexWhere((member) => member.isMainProfile);
        if (mainMemberIndex != -1) {
          _members[mainMemberIndex] = mainMember.copyWith(
            acquaintances: updatedAcquaintances,
          );
        }
      });
    } catch (e) {
      print('Error loading main member: $e');
    }
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
    if (_bottomNavIndex == 2) {
      return PreferredSize(
        preferredSize: Size.zero,
        child: Container(),
      );
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
      appBar: _bottomNavIndex == 0 ? _buildAppBar() : null,
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
                      onAddProfile: () {},
                    ),
                    if (_members.isNotEmpty)
                      AcquaintanceSection(
                        mainMember: _members.firstWhere(
                          (member) => member.isMainProfile,
                          orElse: () => _members.first,
                        ),
                        onAddAcquaintance: _handleAddAcquaintance,
                        onInfoUpdated: _handleInfoUpdate,
                        onDelete: _handleAcquaintanceDelete,
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newsList.length,
                      itemBuilder: (context, index) => NewsCard(news: newsList[index]),
                    ),
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