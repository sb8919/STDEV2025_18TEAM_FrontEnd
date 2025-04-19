class Member {
  final String nickname;
  final String gender;
  final int age;
  final List<String> symptoms;
  final String relationship;
  final bool isMainProfile;
  final List<Acquaintance> acquaintances;
  final HealthMetrics healthMetrics;

  Member({
    required this.nickname,
    required this.gender,
    required this.age,
    required this.symptoms,
    required this.relationship,
    required this.isMainProfile,
    this.acquaintances = const [],
    this.healthMetrics = const HealthMetrics(),
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
    );
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