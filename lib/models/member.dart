class Member {
  final String nickname;
  final String gender;
  final int age;
  final List<String> symptoms;
  final String relationship;
  final bool isMainProfile;
  final List<Acquaintance> acquaintances;
  final HealthMetrics healthMetrics;
  final String loginId;
  final String password;
  final String ageRange;

  Member({
    required this.nickname,
    required this.gender,
    required this.age,
    required this.symptoms,
    this.relationship = '본인',
    this.isMainProfile = false,
    this.acquaintances = const [],
    this.healthMetrics = const HealthMetrics(),
    required this.loginId,
    required this.password,
    required this.ageRange,
  });

  Member copyWith({
    String? nickname,
    String? gender,
    int? age,
    List<String>? symptoms,
    String? relationship,
    bool? isMainProfile,
    List<Acquaintance>? acquaintances,
    HealthMetrics? healthMetrics,
    String? loginId,
    String? password,
    String? ageRange,
  }) {
    return Member(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      symptoms: symptoms ?? this.symptoms,
      relationship: relationship ?? this.relationship,
      isMainProfile: isMainProfile ?? this.isMainProfile,
      acquaintances: acquaintances ?? this.acquaintances,
      healthMetrics: healthMetrics ?? this.healthMetrics,
      loginId: loginId ?? this.loginId,
      password: password ?? this.password,
      ageRange: ageRange ?? this.ageRange,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login_id': loginId,
      'nickname': nickname,
      'password': password,
      'age_range': ageRange,
      'gender': gender,
      'usual_illness': symptoms,
    };
  }
}

class Acquaintance {
  final String name;
  final String relationship;
  final String imagePath;
  final HealthMetrics healthMetrics;

  const Acquaintance({
    required this.name,
    required this.relationship,
    required this.imagePath,
    required this.healthMetrics,
  });

  Acquaintance copyWith({
    String? name,
    String? relationship,
    String? imagePath,
    HealthMetrics? healthMetrics,
  }) {
    return Acquaintance(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      imagePath: imagePath ?? this.imagePath,
      healthMetrics: healthMetrics ?? this.healthMetrics,
    );
  }
}

class HealthMetrics {
  final List<MetricData> metrics;

  const HealthMetrics({
    this.metrics = const [],
  });

  HealthMetrics copyWith({
    List<MetricData>? metrics,
  }) {
    return HealthMetrics(
      metrics: metrics ?? this.metrics,
    );
  }
}

class MetricData {
  final String name;
  final double value;
  final int severityLevel; // 1: 낮음, 2: 중간, 3: 높음

  const MetricData({
    required this.name,
    required this.value,
    required this.severityLevel,
  });
} 