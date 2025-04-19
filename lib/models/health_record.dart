import 'package:intl/intl.dart';

class HealthRecord {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final String type;
  final bool isPinned;

  HealthRecord({
    required this.id,
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
    id: '1',
    date: DateTime(2025, 4, 1),
    title: '월간 건강 체크',
    description: '혈압: 120/80, 체중: 65kg',
    type: '정기검진',
    isPinned: true,
  ),
  
  // 4월 3일
  HealthRecord(
    id: '2',
    date: DateTime(2025, 4, 3),
    title: '새로운 증상',
    description: '목 통증이 있어요',
    type: '통증',
  ),
  
  // 4월 5일
  HealthRecord(
    id: '3',
    date: DateTime(2025, 4, 5),
    title: '알레르기 반응',
    description: '꽃가루 알레르기 증상',
    type: '알레르기',
  ),
  
  // 4월 8일
  HealthRecord(
    id: '4',
    date: DateTime(2025, 4, 8),
    title: '계속 신경 쓰이는 통증이에요!',
    description: '두통이 있어요',
    type: '통증',
    isPinned: true,
  ),
  HealthRecord(
    id: '5',
    date: DateTime(2025, 4, 8),
    title: '오늘의 건강 상태',
    description: '몸이 아파요',
    type: '통증',
  ),
  HealthRecord(
    id: '6',
    date: DateTime(2025, 4, 8),
    title: '새로운 증상',
    description: '손목이 아파요',
    type: '통증',
  ),
  
  // 4월 10일
  HealthRecord(
    id: '7',
    date: DateTime(2025, 4, 10),
    title: '스트레스 체크',
    description: '업무 스트레스로 인한 불면',
    type: '스트레스',
    isPinned: true,
  ),
  
  // 4월 13일
  HealthRecord(
    id: '8',
    date: DateTime(2025, 4, 13),
    title: '주간 건강 체크',
    description: '허리 통증이 있어요',
    type: '통증',
  ),
  
  // 4월 15일
  HealthRecord(
    id: '9',
    date: DateTime(2025, 4, 15),
    title: '운동 후 상태',
    description: '근육통이 있어요',
    type: '운동',
  ),
  
  // 4월 16일
  HealthRecord(
    id: '10',
    date: DateTime(2025, 4, 16),
    title: '정기 검진 결과',
    description: '혈압이 높아요',
    type: '검진',
  ),
]; 