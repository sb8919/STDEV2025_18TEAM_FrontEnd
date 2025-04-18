class Member {
  final String name;
  final String relationship;
  final String imagePath;
  final DateTime recordDate;
  final List<MemberRecord> recentRecords;
  final String nickname;
  final String gender;
  final int age;
  final List<String> symptoms;
  final bool hasProfile;
  final bool isMainProfile;

  Member({
    required this.name,
    required this.relationship,
    this.imagePath = 'assets/logo.png',
    DateTime? recordDate,
    this.recentRecords = const [],
    this.nickname = '',
    this.gender = '',
    this.age = 0,
    this.symptoms = const [],
    this.hasProfile = false,
    this.isMainProfile = false,
  }) : recordDate = recordDate ?? DateTime.now();

  Member copyWith({
    String? name,
    String? relationship,
    String? imagePath,
    DateTime? recordDate,
    List<MemberRecord>? recentRecords,
    String? nickname,
    String? gender,
    int? age,
    List<String>? symptoms,
    bool? hasProfile,
    bool? isMainProfile,
  }) {
    return Member(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      imagePath: imagePath ?? this.imagePath,
      recordDate: recordDate ?? this.recordDate,
      recentRecords: recentRecords ?? this.recentRecords,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      symptoms: symptoms ?? this.symptoms,
      hasProfile: hasProfile ?? this.hasProfile,
      isMainProfile: isMainProfile ?? this.isMainProfile,
    );
  }
}

class MemberRecord {
  final DateTime date;
  final String description;

  const MemberRecord({
    required this.date,
    required this.description,
  });
}

final List<Member> members = [
  Member(
    name: '구성원1',
    relationship: '모',
    nickname: '닉네임',
    gender: '여',
    age: 11,
    symptoms: ['두통', '어지움'],
    hasProfile: true,
    recordDate: DateTime(2024, 4, 5),
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
    recordDate: DateTime(2024, 4, 5),
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