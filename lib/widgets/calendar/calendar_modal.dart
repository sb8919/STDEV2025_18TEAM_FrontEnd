import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/health_record.dart';

class CalendarModal extends StatelessWidget {
  final DateTime date;
  final List<HealthRecord> records;
  final Offset position;

  const CalendarModal({
    super.key,
    required this.date,
    required this.records,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();

    final pinnedRecord = records.firstWhere(
      (record) => record.isPinned,
      orElse: () => records.first,
    );

    // 화면 크기 가져오기
    final screenSize = MediaQuery.of(context).size;
    final modalWidth = 200.0;
    final modalHeight = 250.0;

    // 모달의 x 좌표 계산
    double left = position.dx;
    if (left + modalWidth > screenSize.width) {
      left = screenSize.width - modalWidth - 16; // 오른쪽 여백 16 추가
    }

    // 모달의 y 좌표 계산
    double top = position.dy - modalHeight;
    if (top < 0) {
      top = 16; // 상단 여백 16 추가
    }

    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: modalWidth,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height:10),
                  Text(pinnedRecord.title, style: TextStyle(fontSize:11)),
                  Container(
                    padding: const EdgeInsets.only(left:12, top: 8, right: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset('assets/images/logos/orange_logo.png',height: 50,),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(date),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF5E5E5E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pinnedRecord.description,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF5E5E5E),
                                  fontWeight: FontWeight.w600,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역 축소
                        alignment: Alignment.center, // 정렬
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2), // 텍스트 주변 커스텀 패딩
                        child: Text(
                          '기록 보기',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }
} 