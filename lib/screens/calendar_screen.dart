import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../models/health_record.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;  // 선택된 날짜 상태 추가

  // 기록 유형별 색상 매핑
  final Map<String, Color> _typeColors = {
    '통증': Colors.red,
    '정기검진': Colors.blue,
    '알레르기': Colors.green,
    '스트레스': Colors.purple,
    '운동': Colors.orange,
    '소화기': Colors.teal,
    '피로': Colors.brown,
  };

  // 특정 날짜의 기록 가져오기
  List<HealthRecord> _getRecordsForDate(DateTime date) {
    return healthRecords.where((record) => 
      record.date.year == date.year && 
      record.date.month == date.month && 
      record.date.day == date.day
    ).toList();
  }

  // 특정 날짜에 기록이 있는지 확인
  bool _hasRecordsForDate(DateTime date) {
    return _getRecordsForDate(date).isNotEmpty;
  }

  void _showDateModal(BuildContext context, DateTime date, Offset position, List<HealthRecord> records) {
    if (records.isEmpty) return;

    setState(() {
      _selectedDate = date;  // 날짜 선택 시 상태 업데이트
    });

    final pinnedRecord = records.firstWhere(
      (record) => record.isPinned,
      orElse: () => records.first,
    );

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx - 120,
            top: position.dy - 180,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '계속 신경 쓰이는 통증이에요!',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // 기록 보기 기능 구현
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          '기록 보기',
                          style: TextStyle(
                            fontSize: 14,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 25,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildCalendar(),
                ],
              ),
            ),
            _buildRecordsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logos/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    '닉네임 님,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '이번 달의 건강 신호를 살펴볼까요?',
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/charactor/medit.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('M').format(_focusedDate),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    '월',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['일', '월', '화', '수', '목', '금', '토'].map((day) {
              final isWeekend = day == '일' || day == '토';
              return SizedBox(
                width: 30,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isWeekend ? Colors.red : AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
            final firstWeekday = firstDayOfMonth.weekday;
            final prevMonthDays = (firstWeekday == 7 ? 0 : firstWeekday);
            final day = index - prevMonthDays + 1;
            
            if (day < 1 || day > DateUtils.getDaysInMonth(_focusedDate.year, _focusedDate.month)) {
              return const SizedBox();
            }

            final date = DateTime(_focusedDate.year, _focusedDate.month, day);
            final isToday = DateTime.now().year == date.year &&
                DateTime.now().month == date.month &&
                DateTime.now().day == date.day;
            final isFutureDate = date.isAfter(DateTime.now());
            final records = _getRecordsForDate(date);
            final hasRecords = records.isNotEmpty;
            final isWeekend = date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;
            final isSelected = _selectedDate?.year == date.year &&
                _selectedDate?.month == date.month &&
                _selectedDate?.day == date.day;

            return GestureDetector(
              onTapUp: (TapUpDetails details) {
                if (!isFutureDate && hasRecords) {
                  _showDateModal(context, date, details.globalPosition, records);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                        color: isFutureDate
                            ? Colors.grey.withOpacity(0.5)
                            : isSelected
                                ? Colors.white
                                : isToday
                                    ? Colors.purple
                                    : isWeekend
                                        ? Colors.red
                                        : AppColors.textPrimary,
                      ),
                    ),
                    if (hasRecords && !isFutureDate)
                      Positioned(
                        bottom: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: records.take(3).map((record) {
                            return Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.white 
                                    : _typeColors[record.type] ?? Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRecordsList() {
    // 선택된 날짜가 있으면 해당 날짜의 기록을, 없으면 오늘 날짜의 기록을 보여줌
    final targetDate = _selectedDate ?? DateTime.now();
    final records = _getRecordsForDate(targetDate);
    final dateFormat = DateFormat('M월 d일');
    final displayDate = dateFormat.format(targetDate);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$displayDate의 저장된 신호',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // 전체보기 기능 구현
                },
                child: Row(
                  children: [
                    Text(
                      '전체보기',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (records.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '저장된 신호가 없습니다.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (context, index) => _buildRecordItem(records[index]),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRecordItem(HealthRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.shortFormattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              // 더보기 메뉴 구현
            },
          ),
        ],
      ),
    );
  }
} 