import 'package:intl/intl.dart';

class HealthRecord {
  final DateTime date;
  final String title;
  final String description;
  final String type;
  final bool isPinned;

  HealthRecord({
    required this.date,
    required this.title,
    required this.description,
    this.type = '통증',
    this.isPinned = false,
  });

  String get formattedDate => DateFormat('yyyy-MM-dd').format(date);
  String get shortFormattedDate => DateFormat('M월 d일').format(date);
}

// 예시 데이터
final List<HealthRecord> healthRecords = [
  // 4월 1일
  HealthRecord(
    date: DateTime(2025, 4, 1),
    title: '월간 건강 체크',
    description: '혈압: 120/80, 체중: 65kg',
    type: '정기검진',
    isPinned: true,
  ),
  
  // 4월 3일
  HealthRecord(
    date: DateTime(2025, 4, 3),
    title: '새로운 증상',
    description: '목 통증이 있어요',
    type: '통증',
  ),
  
  // 4월 5일
  HealthRecord(
    date: DateTime(2025, 4, 5),
    title: '알레르기 반응',
    description: '꽃가루 알레르기 증상',
    type: '알레르기',
  ),
  
  // 4월 8일
  HealthRecord(
    date: DateTime(2025, 4, 8),
    title: '계속 신경 쓰이는 통증이에요!',
    description: '두통이 있어요',
    type: '통증',
    isPinned: true,
  ),
  HealthRecord(
    date: DateTime(2025, 4, 8),
    title: '오늘의 건강 상태',
    description: '몸이 아파요',
    type: '통증',
  ),
  HealthRecord(
    date: DateTime(2025, 4, 8),
    title: '새로운 증상',
    description: '손목이 아파요',
    type: '통증',
  ),
  
  // 4월 10일
  HealthRecord(
    date: DateTime(2025, 4, 10),
    title: '스트레스 체크',
    description: '업무 스트레스로 인한 불면',
    type: '스트레스',
    isPinned: true,
  ),
  
  // 4월 13일
  HealthRecord(
    date: DateTime(2025, 4, 13),
    title: '주간 건강 체크',
    description: '허리 통증이 있어요',
    type: '통증',
  ),
  
  // 4월 15일
  HealthRecord(
    date: DateTime(2025, 4, 15),
    title: '운동 후 상태',
    description: '근육통이 있어요',
    type: '운동',
  ),
  
  // 4월 16일
  HealthRecord(
    date: DateTime(2025, 4, 16),
    title: '정기 검진 결과',
    description: '혈압이 높아요',
    type: '검진',
    isPinned: true,
  ),
  
  // 4월 18일
  HealthRecord(
    date: DateTime(2025, 4, 18),
    title: '식단 관리',
    description: '소화불량 증상',
    type: '소화기',
  ),
  
  // 4월 19일 (오늘)
  HealthRecord(
    date: DateTime.now(),
    title: '오늘의 컨디션',
    description: '피로감이 있어요',
    type: '피로',
    isPinned: true,
  ),
]; 