import 'package:flutter/material.dart';
import '../models/health_record.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthRecordDetailScreen extends StatelessWidget {
  final HealthRecord record;
  final DateTime date;

  const HealthRecordDetailScreen({
    Key? key,
    required this.record,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          '${DateFormat('M월 d일 EEEE', 'ko_KR').format(date)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('닉네임 님,',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),),
                    Text(
                      '밤 10시 이전에 잠들어 보세요!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              _buildSymptomGrid(context),
              SizedBox(height: 24),
              _buildPainLevelSection(),
              SizedBox(height: 24),
              _buildRecommendationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSymptomGrid(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계속 신경 쓰이는 통증이에요!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
            children: [
              _buildSymptomItem(context, '두통', Icons.sick),
              _buildSymptomItem(context, '딱딱통증', Icons.healing),
              _buildSymptomItem(context, '어지러움', Icons.motion_photos_on),
              _buildSymptomItem(context, '피곤함', Icons.nightlight_round),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomItem(BuildContext context, String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Color(0xFF005BAC), size: 24),
                    SizedBox(width: 12),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  '증상 설명',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _getSymptomDescription(label),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '관리 방법',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                ..._getSymptomManagement(label).map((tip) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline, 
                        color: Color(0xFF005BAC),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey[600]),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getSymptomDescription(String symptom) {
    switch (symptom) {
      case '두통':
        return '두통은 머리 부위에 느껴지는 통증으로, 스트레스, 피로, 수면 부족 등 다양한 원인으로 발생할 수 있습니다. 특히 밤늦게까지 깨어있거나 불규칙한 수면 패턴이 지속될 경우 두통이 자주 발생할 수 있습니다.';
      case '딱딱통증':
        return '딱딱한 느낌의 통증은 주로 근육의 긴장이나 염증으로 인해 발생합니다. 장시간 같은 자세를 유지하거나 과도한 스트레스로 인해 근육이 경직되면서 나타날 수 있습니다.';
      case '어지러움':
        return '어지러움은 균형감각의 이상이나 피로, 수면 부족 등으로 인해 발생할 수 있습니다. 특히 수면 부족이 지속되면 뇌가 충분한 휴식을 취하지 못해 어지러움을 느낄 수 있습니다.';
      case '피곤함':
        return '피곤함은 신체적, 정신적 에너지가 소진된 상태를 의미합니다. 불규칙한 수면 패턴, 과도한 활동, 스트레스 등이 주요 원인이 될 수 있으며, 특히 수면의 질이 좋지 않을 때 더욱 심해질 수 있습니다.';
      default:
        return '증상에 대한 자세한 설명이 필요합니다.';
    }
  }

  List<String> _getSymptomManagement(String symptom) {
    switch (symptom) {
      case '두통':
        return [
          '규칙적인 수면 시간 유지하기',
          '충분한 수분 섭취하기',
          '스트레스 관리하기',
          '적절한 휴식 취하기',
          '필요한 경우 진통제 복용하기',
        ];
      case '딱딱통증':
        return [
          '가벼운 스트레칭하기',
          '마사지나 찜질하기',
          '바른 자세 유지하기',
          '규칙적인 운동하기',
        ];
      case '어지러움':
        return [
          '충분한 수면 취하기',
          '갑작스러운 움직임 피하기',
          '수분과 영양분 섭취하기',
          '필요한 경우 의사와 상담하기',
        ];
      case '피곤함':
        return [
          '밤 10시 이전에 취침하기',
          '카페인 섭취 줄이기',
          '적절한 운동하기',
          '충분한 휴식 취하기',
          '규칙적인 생활 패턴 유지하기',
        ];
      default:
        return ['증상 관리 방법이 필요합니다.'];
    }
  }

  Widget _buildPainLevelSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '현재 증상은 다음과 같은 가능성이 있어요!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF005BAC),
                        value: 60,
                        title: '60%',
                        radius: 40,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: const Color(0xFF4C95D4),
                        value: 30,
                        title: '30%',
                        radius: 40,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFA5CAF0),
                        value: 10,
                        title: '10%',
                        radius: 40,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem('편두통', '60%', const Color(0xFF005BAC)),
                    SizedBox(height: 8),
                    _buildLegendItem('긴장성 두통', '30%', const Color(0xFF4C95D4)),
                    SizedBox(height: 8),
                    _buildLegendItem('기타', '10%', const Color(0xFFA5CAF0)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          percentage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이렇게 해보세요!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildRecommendationItem('수분 충분히 섭취하기'),
          _buildRecommendationItem('8시간 이상 수면 시도'),
          _buildRecommendationItem('2일 이상 증상 지속 시 병원 상담'),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
} 