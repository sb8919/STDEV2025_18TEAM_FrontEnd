import 'package:flutter/material.dart';
import '../../../models/member.dart';

class HealthMetricBar extends StatelessWidget {
  final MetricData metric;
  final double barWidth;
  final double barHeight;

  const HealthMetricBar({
    super.key,
    required this.metric,
    this.barWidth = 24.0,
    this.barHeight = 80.0,
  });

  Color _getSeverityColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF91D7E0); // 연한 청록색
      case 2:
        return const Color(0xFFFF9E9E); // 연한 주황색
      case 3:
        return const Color(0xFFFF6B6B); // 진한 주황색
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 막대 차트
        Container(
          width: barWidth,
          height: barHeight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: barWidth,
              height: barHeight * metric.value,
              decoration: BoxDecoration(
                color: _getSeverityColor(metric.severityLevel),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                  bottom: Radius.zero,
                ),
              ),
            ),
          ),
        ),
        // 지표 이름
        const SizedBox(height: 8),
        SizedBox(
          width: barWidth + 8,
          child: Text(
            metric.name,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF868686),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
} 