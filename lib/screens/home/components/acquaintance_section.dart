import 'package:flutter/material.dart';
import 'package:stdev2025_18team_frontend/constants/app_colors.dart';
import '../../../models/member.dart';
import '../../../screens/add_friend_screen.dart';
import 'acquaintance_card.dart';

class AcquaintanceSection extends StatelessWidget {
  final Member mainMember;
  final Function(Map<String, dynamic>) onAddAcquaintance;
  final Function(Acquaintance, String, String) onInfoUpdated;
  final Function(Acquaintance) onDelete;

  const AcquaintanceSection({
    super.key,
    required this.mainMember,
    required this.onAddAcquaintance,
    required this.onInfoUpdated,
    required this.onDelete,
  });

  void _showAddFriendScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFriendScreen(
          onAddFriend: onAddAcquaintance,
        ),
      ),
    );
  }

  Widget _buildAcquaintanceCard(BuildContext context, Acquaintance acquaintance) {
    return AcquaintanceCard(
      acquaintance: acquaintance,
      cardWidth: MediaQuery.of(context).size.width / 2 - 30,
      onInfoUpdated: (name, relationship) {
        onInfoUpdated(acquaintance, name, relationship);
      },
      onDelete: (_) => onDelete(acquaintance),
    );
  }

  Widget _buildAddCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddFriendScreen(context),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 30,
        height: 200,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              size: 32,
              color: AppColors.purpple,
            ),
            const SizedBox(height: 5),
            Text(
              '추가하기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          spacing: 10,
          runSpacing: 10,
          children: [
            ...mainMember.acquaintances.map((acquaintance) => _buildAcquaintanceCard(context, acquaintance)),
            if (mainMember.acquaintances.length < 4)
              _buildAddCard(context),
          ],
        ),
      ],
    );
  }
} 