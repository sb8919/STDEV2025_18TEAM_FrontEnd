import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../services/chat_service.dart';
import '../services/symptom_service.dart';
import '../widgets/body_part_selector.dart';
import '../widgets/pain_intensity_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import '../utils/profile_image_utils.dart';

class ChatScreen extends StatefulWidget {
  final Set<BodyPart> selectedBodyParts;
  final String symptom;
  final String duration;
  final double painIntensity;

  const ChatScreen({
    super.key,
    required this.selectedBodyParts,
    required this.symptom,
    required this.duration,
    required this.painIntensity,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  final SymptomService _symptomService = SymptomService();
  bool _isLoading = false;
  String? _conversationId;
  String? _userId;
  String? _loginId;
  String? _selectedFeeling;
  String? _selectedDuration;
  double _painIntensity = 0.0;
  bool _showFeelingOptions = false;
  bool _showDurationOptions = false;
  bool _showPainSlider = false;
  bool _showCustomDurationInput = false;
  bool _showYesNoOptions = false;
  bool _showDiseaseChart = false;
  bool _showSaveOptions = false;
  Map<String, dynamic> _diseaseReports = {};
  
  final List<String> _symptoms = [
    '통증',
    '부종',
    '발열',
    '가려움',
    '저림',
  ];

  List<String> _feelings = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  String _bodyPartToKorean() {
    return widget.selectedBodyParts.map((part) {
      switch (part) {
        case BodyPart.head:
          return '머리';
        case BodyPart.chest:
          return '가슴';
        case BodyPart.abdomen:
          return '배';
        case BodyPart.leftArm:
          return '왼팔';
        case BodyPart.rightArm:
          return '오른팔';
        case BodyPart.leftLeg:
          return '왼다리';
        case BodyPart.rightLeg:
          return '오른다리';
        default:
          return '';
      }
    }).join(', ');
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _loginId = prefs.getString('login_id');
    
    print('Loaded login ID: $_loginId');
    
    if (_loginId == null) {
      _addBotMessage('로그인이 필요합니다. 로그인 후 다시 시도해주세요.');
      return;
    }
    
    _initializeConversation();
  }

  Future<void> _initializeConversation() async {
    if (_loginId == null) return;
    
    setState(() => _isLoading = true);
    try {
      final bodyPart = widget.selectedBodyParts.first;
      _feelings = _symptomService.getFeelingsForBodyPart(bodyPart);
      
      final initialMessage = '${_bodyPartToKorean()} 부위가 어떻게 느껴지시나요?';
      final response = await _chatService.createConversation(_loginId!, messageContent: initialMessage);
      
      _conversationId = response['id'];
      _userId = response['user_id'];
      
      if (response['conversation_message'] != null) {
        final aiMessage = response['conversation_message'];
        _addBotMessage(aiMessage['content']);
        setState(() {
          _showFeelingOptions = true;
        });
      }
    } catch (e) {
      print('Error in _initializeConversation: $e');
      _addBotMessage('죄송합니다. 서버와의 연결에 문제가 발생했습니다.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onFeelingSelected(String feeling) {
    setState(() {
      _selectedFeeling = feeling;
      _showFeelingOptions = false;
    });

    _addUserMessage(feeling);
    _addBotMessage('며칠째 이런 증상이 있으신가요?');
    
    setState(() {
      _showDurationOptions = true;
    });
  }

  void _onDurationSelected(String duration) {
    if (duration == '직접 입력') {
      setState(() {
        _showDurationOptions = false;
        _showCustomDurationInput = true;
      });
      return;
    }

    setState(() {
      _selectedDuration = duration;
      _showDurationOptions = false;
    });

    _addUserMessage(duration);
    _addBotMessage('통증 정도는 어느 정도인가요?');
    
    setState(() {
      _showPainSlider = true;
    });
  }

  void _onPainIntensityChanged(double value) {
    setState(() {
      _painIntensity = value;
    });
  }

  void _onPainIntensitySubmit() {
    setState(() {
      _showPainSlider = false;
    });

    _addUserMessage('통증 강도: ${_painIntensity.toStringAsFixed(1)}');
    
    // 모든 정보가 수집되면 서버로 전송
    _submitSymptomInfo();
  }

  Future<void> _submitSymptomInfo() async {
    if (_loginId == null || _selectedFeeling == null || _selectedDuration == null) return;

    final symptomData = {
      'login_id': _loginId,
      'body_parts': widget.selectedBodyParts.map((part) => part.toString()).toList(),
      'feeling': _selectedFeeling,
      'duration': _selectedDuration,
      'pain_intensity': _painIntensity,
      'symptom': widget.symptom,
    };
    
    print('=== Symptom Data to be sent ===');
    print(json.encode(symptomData));
    print('============================');

    setState(() => _isLoading = true);

    try {
      final messageContent = '${_bodyPartToKorean()}에서 ${_selectedFeeling}한 증상이 있으며, '
          '지속 기간은 ${_selectedDuration}이고, 통증 강도는 ${_painIntensity}점입니다.';

      final conversationResponse = await _chatService.createConversation(
        _loginId!,
        messageContent: messageContent,
      );
      
      _conversationId = conversationResponse['id'];
      
      setState(() {
        // 첫 번째 메시지: 증상 설명
        _messages.add(ChatMessage(
          text: "편두통, 긴장성 두통의 가능성이 있어요!",
          isUser: false,
        ));

        // 두 번째 메시지: 원인 분석
        _messages.add(ChatMessage(
          text: "카페인 과다 섭취, 수면 부족, 스트레스가 원인일 수 있어요!",
          isUser: false,
        ));

        // 세 번째 메시지: 조언
        _messages.add(ChatMessage(
          text: "물을 분히 마시고 조용한 곳에서 휴식을 취하는 걸 추천드려요!",
          isUser: false,
        ));

        // 네 번째 메시지: 경고
        _messages.add(ChatMessage(
          text: "하지만 아래 증상이 지속된다면 병원을 꼭 가보세요!",
          isUser: false,
        ));

        // 다섯 번째 메시지: 경고 증상 리스트
        _messages.add(ChatMessage(
          text: _buildWarningSymptomsList(),
          isUser: false,
          isWarningList: true,
        ));
      });

      // 마지막 메시지를 sendMessageToUserConversation을 통해 전송
      final followUpResponse = await _chatService.sendMessageToUserConversation(
        _loginId!,
        _conversationId!,
        "더 알고 싶은 게 있다면 말씀해 주세요!",
      );

      if (followUpResponse['conversation_message'] != null) {
        setState(() {
          _messages.add(ChatMessage(
            text: followUpResponse['conversation_message']['content'],
            isUser: false,
          ));
          _showYesNoOptions = true;
          _isLoading = false;
        });
      }

    } catch (e) {
      print('Error in _submitSymptomInfo: $e');
      setState(() {
        _messages.add(ChatMessage(
          text: "죄송합니다. 오류가 발생했습니다.",
          isUser: false,
        ));
        _isLoading = false;
      });
    }
  }

  String _buildWarningSymptomsList() {
    return """warning_list
일주일 이상 지속되는 두통
진통제 복용에도 호전 없음
시야 흐림, 어지럼증 동반
고열, 구토, 말 어눌함
갑자기 시작된 극심한 두통""";
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: false));
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _messageController.clear();

    if (_showCustomDurationInput) {
      setState(() {
        _selectedDuration = text;
        _showCustomDurationInput = false;
      });
      _addBotMessage('통증 정도는 어느 정도인가요?');
      setState(() {
        _showPainSlider = true;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _chatService.sendMessageToUserConversation(
        _loginId!,
        _conversationId!,
        text,
      );
      
      if (response['conversation_message'] != null) {
        final aiMessage = response['conversation_message']['content'];
        _addBotMessage(aiMessage);
      }
    } catch (e) {
      print('Error sending message: $e');
      _addBotMessage('죄송합니다. 메시지 전송에 실패했습니다.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildFeelingOptions() {
    return Align( // 중앙 정렬
      alignment: Alignment.centerLeft,
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white, // 배경 흰색
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDADFF7), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_feelings.length, (index) {
            final isLast = index == _feelings.length - 1;
            return Column(
              children: [
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    _feelings[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => _onFeelingSelected(_feelings[index]),
                  tileColor: Colors.transparent,
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    color: Color(0xFFDADFF7),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDurationOptions() {
    final durations = SymptomService.durationOptions;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDADFF7), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(durations.length, (index) {
            final isLast = index == durations.length - 1;
            return Column(
              children: [
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    durations[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => _onDurationSelected(durations[index]),
                  tileColor: Colors.transparent,
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    color: Color(0xFFDADFF7),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }


  Widget _buildPainIntensitySlider() {
    return Column(
      children: [
        PainIntensitySlider(
          value: _painIntensity,
          onChanged: _onPainIntensityChanged,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _onPainIntensitySubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF394BF5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            '선택 완료',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYesNoOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showYesNoOptions = false;
                    _messages.add(ChatMessage(
                      text: "네, 더 자세히 알고 싶습니다.",
                      isUser: true,
                    ));
                    // 추가 질문을 위해 입력창에 포커스
                    FocusScope.of(context).requestFocus(_messageFocusNode);
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: const Text(
                    "예",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    _showYesNoOptions = false;
                    _messages.add(ChatMessage(
                      text: "아니요, 리포트를 요약해주세요.",
                      isUser: true,
                    ));
                  });
                  
                  try {
                    // 대화 보고서 생성
                    final reportData = {
                      "title": "${_bodyPartToKorean()} 증상 분석",
                      "summary": "증상 분석 및 건강 제안",
                      "content": "사용자가 보고한 증상에 대한 분석 결과입니다.",
                      "detected_symptoms": [
                        "${_bodyPartToKorean()}의 ${_selectedFeeling}한 증상",
                        "지속 기간: ${_selectedDuration}",
                        "통증 강도: ${_painIntensity}점"
                      ],
                      "diseases_with_probabilities": [
                        {"name": "편두통", "probability": 75},
                        {"name": "긴장성 두통", "probability": 15},
                        {"name": "부비동염", "probability": 10}
                      ],
                      "health_suggestions": [
                        "충분한 수분 섭취",
                        "조용한 환경에서 휴식",
                        "규칙적인 수면 습관 유지",
                        "스트레스 관리"
                      ]
                    };

                    final reportResponse = await _chatService.createConversationReport(
                      _conversationId!,
                      reportData,
                    );

                    setState(() {
                      _diseaseReports = reportResponse;
                      _messages.add(ChatMessage(
                        text: "증상을 분석한 결과입니다.",
                        isUser: false,
                      ));
                      _showDiseaseChart = true;
                    });

                    // 차트가 표시된 후 저장 여부 메시지 추가
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        _messages.add(ChatMessage(
                          text: "메딧톡 내에 저장할까요?",
                          isUser: false,
                        ));
                        _showSaveOptions = true;
                        _showDiseaseChart = false;  // 차트는 메시지로 변환
                        
                        // 차트를 메시지로 변환하여 추가
                        _messages.add(ChatMessage(
                          text: """chart_data
편두통|75
긴장성 두통|15
부비동염|10""",
                          isUser: false,
                          isChart: true,
                        ));
                      });
                    });
                  } catch (e) {
                    print('Error creating/getting report: $e');
                    setState(() {
                      _messages.add(ChatMessage(
                        text: "죄송합니다. 리포트 생성에 실패했습니다.",
                        isUser: false,
                      ));
                    });
                  }
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: const Text(
                    "아니요",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseChart() {
    if (_diseaseReports.isEmpty) return Container();

    final List<PieChartSectionData> sections = [];
    final colors = [
      const Color(0xFF394BF5),  // 진한 파랑
      const Color(0xFFDADFF7),  // 연한 파랑
      const Color(0xFFF5F6FE),  // 더 연한 파랑
    ];

    int colorIndex = 0;
    final diseases = _diseaseReports['diseases_with_probabilities'] as List<dynamic>? ?? [];

    for (var disease in diseases) {
      sections.add(
        PieChartSectionData(
          value: disease['probability']?.toDouble() ?? 0,
          title: '',
          color: colors[colorIndex % colors.length],
          radius: 15,
          showTitle: false,
        ),
      );
      colorIndex++;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 270,  // ChatMessage와 동일한 너비
        margin: const EdgeInsets.only(right: 80, top: 8, bottom: 8),  // ChatMessage와 유사한 마진
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDADFF7), width: 1),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 20,
                    sectionsSpace: 0,
                    startDegreeOffset: -90,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: diseases.asMap().entries.map((entry) {
                    final index = entry.key;
                    final disease = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            disease['name'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${disease['probability'].toString()}%',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showSaveOptions = false;
                    _messages.add(ChatMessage(
                      text: "저장되었습니다.",
                      isUser: false,
                    ));
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: const Text(
                    "예",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showSaveOptions = false;
                    _messages.add(ChatMessage(
                      text: "저장하지 않았습니다.",
                      isUser: false,
                    ));
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: const Text(
                    "아니요",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateString =
        '${today.year}년 ${today.month}월 ${today.day}일 ${["일", "월", "화", "수", "목", "금", "토"][today.weekday % 7]}요일';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '메딧톡',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: const SizedBox(),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      dateString,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length + (_showFeelingOptions || _showDurationOptions || _showPainSlider || _showYesNoOptions || _showDiseaseChart || _showSaveOptions ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _messages.length) {
                    return _messages[index].buildWidget();
                  } else {
                    if (_showFeelingOptions) {
                      return _buildFeelingOptions();
                    } else if (_showDurationOptions) {
                      return _buildDurationOptions();
                    } else if (_showPainSlider) {
                      return _buildPainIntensitySlider();
                    } else if (_showYesNoOptions) {
                      return _buildYesNoOptions();
                    } else if (_showDiseaseChart) {
                      return _buildDiseaseChart();
                    } else if (_showSaveOptions) {
                      return _buildSaveOptions();
                    }
                    return const SizedBox();
                  }
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('조금만 기다려주세요...', style: TextStyle(color: Colors.grey)),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon/plus.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // TODO: 추가 기능 구현
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        textInputAction: TextInputAction.send,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: _showCustomDurationInput 
                              ? '기간을 입력하세요 (예: 2주일)' 
                              : '메시지를 입력하세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon/mic.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // TODO: 음성 입력 기능 구현
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isWarningList;
  final bool isChart;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isWarningList = false,
    this.isChart = false,
  });

  Widget buildWidget() {
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.zero,
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      if (isChart && text.startsWith('chart_data')) {
        final data = text.replaceFirst('chart_data\n', '').split('\n');
        final List<PieChartSectionData> sections = [];
        final colors = [
          const Color(0xFF394BF5),  // 진한 파랑
          const Color(0xFFDADFF7),  // 연한 파랑
          const Color(0xFFF5F6FE),  // 더 연한 파랑
        ];

        final diseases = data.map((line) {
          final parts = line.split('|');
          return {
            'name': parts[0],
            'probability': double.parse(parts[1]),
          };
        }).toList();

        for (var i = 0; i < diseases.length; i++) {
          sections.add(
            PieChartSectionData(
              value: diseases[i]['probability'] as double,
              title: '',
              color: colors[i % colors.length],
              radius: 15,
              showTitle: false,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(right: 80, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildProfileCircle('남', 25, size: 46),
                  const SizedBox(width: 8),
                  const Text(
                    '메딧톡',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                width: 270,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDADFF7), width: 1),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            centerSpaceRadius: 20,
                            sectionsSpace: 0,
                            startDegreeOffset: -90,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: diseases.asMap().entries.map((entry) {
                            final index = entry.key;
                            final disease = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: colors[index % colors.length],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    disease['name'].toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${disease['probability'].toString()}%',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      } else if (isWarningList && text.startsWith('warning_list')) {
        final symptoms = text.replaceFirst('warning_list\n', '').split('\n');
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 270,
            margin: const EdgeInsets.only(top: 8, bottom: 12, right: 80),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFDADFF7), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(symptoms.length, (index) {
                final isLast = index == symptoms.length - 1;
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      title: Text(
                        symptoms[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      tileColor: Colors.transparent,
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        color: Color(0xFFDADFF7),
                      ),
                  ],
                );
              }),
            ),
          ),
        );
      }
      
      return Padding(
        padding: const EdgeInsets.only(right: 80, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildProfileCircle('남', 25, size: 46),
                const SizedBox(width: 8),
                const Text(
                  '메딧톡',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(left: 0),
              constraints: const BoxConstraints(maxWidth: 270),
              decoration: BoxDecoration(
                color: const Color(0xFFC3CCF5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    }
  }
}
