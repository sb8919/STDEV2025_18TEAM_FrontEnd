import 'package:flutter/material.dart';
import '../../../models/member.dart';
import '../../../screens/edit_relationship_screen.dart';
import '../../../utils/profile_image_utils.dart';
import 'health_metric_bar.dart';

class AcquaintanceCard extends StatelessWidget {
  final Acquaintance acquaintance;
  final double cardWidth;
  final double cardHeight;
  final VoidCallback? onTap;
  final Function(String, String)? onInfoUpdated;
  final Function(String)? onDelete;

  const AcquaintanceCard({
    super.key,
    required this.acquaintance,
    required this.cardWidth,
    this.cardHeight = 200.0,
    this.onTap,
    this.onInfoUpdated,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  buildProfileCircle(acquaintance.gender, acquaintance.age, size: 40),
                  const SizedBox(width: 10),
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
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '관계 | ${acquaintance.relationship}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF868686),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: (acquaintance.healthMetrics?.metrics ?? []).map((metric) {
                  return HealthMetricBar(metric: metric);
                }).toList(),
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: -20,
            child: IconButton(
              icon: const Icon(Icons.edit_note_outlined, color: Colors.black, size: 14),
              onPressed: () async {
                final result = await Navigator.push<Map<String, String>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditRelationshipScreen(
                      acquaintance: acquaintance,
                      onDelete: onDelete,
                    ),
                  ),
                );
                
                if (result != null && onInfoUpdated != null) {
                  onInfoUpdated?.call(result['name']!, result['relationship']!);
                }
              },
              splashRadius: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Edit',
            ),
          ),
        ],
      ),
    );
  }
} 