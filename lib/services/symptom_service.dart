import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/body_part_selector.dart';

class SymptomService {
  static const String baseUrl = 'http://52.79.80.204';

  // 신체 부위별 느낌 매핑
  static const Map<BodyPart, List<String>> bodyPartFeelings = {
    BodyPart.head: [
      '지끈지끈',
      '욱신욱신',
      '띵하게',
      '멍하게',
      '둔하게',
    ],
    BodyPart.chest: [
      '답답하게',
      '뻐근하게',
      '찌르듯이',
      '묵직하게',
      '타들어가듯',
    ],
    BodyPart.abdomen: [
      '쓰리듯이',
      '울렁거리게',
      '당기듯이',
      '뒤틀리듯이',
      '팽팽하게',
    ],
    BodyPart.leftArm: [
      '저리게',
      '뻣뻣하게',
      '찌릿찌릿',
      '아리아리',
      '뻐근하게',
    ],
    BodyPart.rightArm: [
      '저리게',
      '뻣뻣하게',
      '찌릿찌릿',
      '아리아리',
      '뻐근하게',
    ],
    BodyPart.leftLeg: [
      '저리게',
      '뻣뻣하게',
      '후들후들',
      '쥐나듯이',
      '뻐근하게',
    ],
    BodyPart.rightLeg: [
      '저리게',
      '뻣뻣하게',
      '후들후들',
      '쥐나듯이',
      '뻐근하게',
    ],
  };

  // 기간 선택 옵션
  static const List<String> durationOptions = [
    '~1일',
    '2~3일',
    '일주일 이상',
    '직접 입력',
  ];

  Future<Map<String, dynamic>> submitSymptomInfo(
    String loginId,
    Set<BodyPart> bodyParts,
    String feeling,
    String duration,
    double painIntensity,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$loginId/symptoms'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'body_parts': bodyParts.map((part) => part.toString().split('.').last).toList(),
          'feeling': feeling,
          'duration': duration,
          'pain_intensity': painIntensity,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Server response: ${response.body}');
        throw Exception('Failed to submit symptom info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting symptom info: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  List<String> getFeelingsForBodyPart(BodyPart bodyPart) {
    return bodyPartFeelings[bodyPart] ?? [];
  }

  Future<Map<String, dynamic>> createConversation(String loginId, Map<String, dynamic> symptomData) async {
    final url = Uri.parse('$baseUrl/users/$loginId/conversations/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'symptom_data': symptomData,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      print('Server response: ${response.body}');
      throw Exception('Failed to create conversation');
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> getDiseaseReports(String loginId) async {
    final url = Uri.parse('$baseUrl/users/$loginId/reports/diseases/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Map<String, List<Map<String, dynamic>>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch disease reports');
    }
  }
} 