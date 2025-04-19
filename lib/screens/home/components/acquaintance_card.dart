import 'package:flutter/material.dart';
import '../../../models/member.dart';
import 'health_metric_bar.dart';

class AcquaintanceCard extends StatelessWidget {
  final Acquaintance acquaintance;
  final double cardWidth;
  final double cardHeight;
  final VoidCallback? onTap;

  const AcquaintanceCard({
    super.key,
    required this.acquaintance,
    required this.cardWidth,
    this.cardHeight = 200.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 정보
          Row(
            children: [
              Image.asset(
                acquaintance.imagePath,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      acquaintance.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '관계 | ${acquaintance.relationship}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF868686),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // 건강 지표 차트
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: acquaintance.healthMetrics.metrics.map((metric) {
              return HealthMetricBar(metric: metric);
            }).toList(),
          ),
        ],
      ),
    );
  }
} 