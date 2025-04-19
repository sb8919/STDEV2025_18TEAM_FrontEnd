class Member {
  final String nickname;
  final String gender;
  final int age;
  final List<String> symptoms;
  final String relationship;
  final bool isMainProfile;

  Member({
    required this.nickname,
    required this.gender,
    required this.age,
    required this.symptoms,
    required this.relationship,
    required this.isMainProfile,
  });

  Member copyWith({
    String? nickname,
    String? gender,
    int? age,
    List<String>? symptoms,
    String? relationship,
    bool? isMainProfile,
  }) {
    return Member(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      symptoms: symptoms ?? this.symptoms,
      relationship: relationship ?? this.relationship,
      isMainProfile: isMainProfile ?? this.isMainProfile,
    );
  }
} 