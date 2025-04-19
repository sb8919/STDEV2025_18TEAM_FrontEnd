import 'package:flutter/material.dart';
import '../../../models/member.dart';
import 'search_medit_id_dialog.dart';

class AcquaintanceSection extends StatelessWidget {
  final Member mainMember;
  final Function(Map<String, dynamic>) onAddAcquaintance;

  const AcquaintanceSection({
    super.key,
    required this.mainMember,
    required this.onAddAcquaintance,
  });

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SearchMeditIdDialog(
        onUserSelected: onAddAcquaintance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mainMember.acquaintances.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          '${mainMember.nickname}님, 지인의 이상 신호 소식이에요!',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 16,
          children: [
            ...mainMember.acquaintances.map((acquaintance) => _buildAcquaintanceCard(context, acquaintance)),
            if (mainMember.acquaintances.length < 4)
              _buildAddCard(context),
          ],
        ),
      ],
    );
  }

  Widget _buildAcquaintanceCard(BuildContext context, Acquaintance acquaintance) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 30,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: acquaintance.healthMetrics.metrics.map((metric) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 24,
                    height: 80,
                    child: Stack(
                      children: [
                        Container(
                          width: 24,
                          height: 80 * metric.value,
                          margin: EdgeInsets.only(top: 80 * (1 - metric.value)),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(metric.severityLevel),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 32,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        metric.name,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF868686),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSearchDialog(context),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 30,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 32,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              '추가하기',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
} 