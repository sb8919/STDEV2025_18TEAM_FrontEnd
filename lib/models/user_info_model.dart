class UserInfoModel {
  final String loginId;
  final String nickname;
  final String gender;
  final String age;
  final List<String> symptoms;

  UserInfoModel({
    required this.loginId,
    required this.nickname,
    required this.gender,
    required this.age,
    this.symptoms = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'nickname': nickname,
      'gender': gender,
      'age': age,
      'symptoms': symptoms,
    };
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      loginId: json['loginId'] as String,
      nickname: json['nickname'] as String,
      gender: json['gender'] as String,
      age: json['age'] as String,
      symptoms: List<String>.from(json['symptoms'] ?? []),
    );
  }
} 