class Member {
  final String name;
  final String relationship;
  final String imagePath;
  final List<MemberRecord> recentRecords;

  const Member({
    required this.name,
    required this.relationship,
    this.imagePath = 'assets/logo.png',
    this.recentRecords = const [],
  });
}

class MemberRecord {
  final DateTime date;
  final String description;

  const MemberRecord({
    required this.date,
    required this.description,
  });
}

List<Member> members = [
  Member(
    name: '구성원1',
    relationship: '모',
    recentRecords: [
      MemberRecord(
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: '계단에서 넘어짐',
      ),
      MemberRecord(
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: '두통',
      ),
      MemberRecord(
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: '감기 증상',
      ),
    ],
  ),
  Member(
    name: '구성원2',
    relationship: '부',
    recentRecords: [
      MemberRecord(
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: '허리 통증',
      ),
      MemberRecord(
        date: DateTime.now().subtract(const Duration(days: 4)),
        description: '어깨 통증',
      ),
    ],
  ),
]; 