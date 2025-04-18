import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/member_data.dart';
import '../constants/app_colors.dart';
import 'profile_screen.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  Member? _selectedMember;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('구성원 추가하기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '구성원의 이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _relationshipController,
              decoration: const InputDecoration(
                labelText: '관계',
                hintText: '관계를 입력하세요 (예: 모, 부, 자녀)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nameController.clear();
              _relationshipController.clear();
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _relationshipController.text.isNotEmpty) {
                setState(() {
                  members.add(
                    Member(
                      name: _nameController.text,
                      relationship: _relationshipController.text,
                    ),
                  );
                });
                Navigator.pop(context);
                _nameController.clear();
                _relationshipController.clear();
              }
            },
            child: Text(
              '추가',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...members.map((member) => _buildExpandableMemberCard(member)).toList(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 25),
            child: Divider(
              color: AppColors.dividerColor,
              thickness: 1,
              height: 0,
            ),
          ),
          InkWell(
            onTap: _showAddMemberDialog,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '구성원 추가하기',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableMemberCard(Member member) {
    final isSelected = _selectedMember == member;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _selectedMember = isSelected ? null : member;
              });
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildMemberAvatar(member),
                  const SizedBox(width: 16),
                  _buildMemberInfo(member),
                ],
              ),
            ),
          ),
          if (isSelected) _buildRecordsList(member),
        ],
      ),
    );
  }

  Widget _buildRecordsList(Member member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${DateFormat('MM월 dd일').format(member.recordDate)} 기록',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...member.recentRecords.map((record) => _buildRecordItem(record)).toList(),
        if (member.recentRecords.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '계속 보려면 눌러주세요',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRecordItem(MemberRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            record.description,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(Member member) {
    return Image.asset(
      member.imagePath,
      height: 30,
      width: 30,
    );
  }

  Widget _buildMemberInfo(Member member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMemberName(member),
        const SizedBox(height: 4),
        _buildMemberRelationship(member),
      ],
    );
  }

  Widget _buildMemberName(Member member) {
    return Text(
      member.name,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildMemberRelationship(Member member) {
    return Row(
      children: [
        Text(
          '관계 | ',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        Text(
          member.relationship,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
} 