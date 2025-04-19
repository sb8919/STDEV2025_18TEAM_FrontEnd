import 'package:flutter/material.dart';
import '../../../models/member.dart';
import 'acquaintance_card.dart';

class AcquaintanceSection extends StatelessWidget {
  final Member mainMember;
  final VoidCallback? onAddTap;

  const AcquaintanceSection({
    super.key,
    required this.mainMember,
    this.onAddTap,
  });

  Widget _buildAddCard(double cardWidth) {
    return GestureDetector(
      onTap: onAddTap,
      child: Container(
        width: cardWidth,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[400]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 32,
              color: Colors.grey[600],
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

  @override
  Widget build(BuildContext context) {
    if (mainMember.acquaintances.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 60) / 2; // 20 padding on each side + 20 spacing

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
          runSpacing: 20,
          children: [
            ...mainMember.acquaintances.map(
              (acquaintance) => AcquaintanceCard(
                acquaintance: acquaintance,
                cardWidth: cardWidth,
              ),
            ),
            if (mainMember.acquaintances.length < 4)
              _buildAddCard(cardWidth),
          ],
        ),
      ],
    );
  }
} 