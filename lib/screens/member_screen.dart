import 'package:flutter/material.dart';
import '../constants/member_data.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            child: const Text('추가'),
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
    return Column(
      children: [
        ...members.map((member) => _buildMemberCard(member)).toList(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 0,
          ),
        ),
        InkWell(
          onTap: _showAddMemberDialog,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '구성원 추가하기',
                  style: TextStyle(
                    color: Colors.purple[200],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.purple[200],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(Member member) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildMemberAvatar(member),
          const SizedBox(width: 16),
          _buildMemberInfo(member),
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMemberRelationship(Member member) {
    return Row(
      children: [
        const Text(
          '관계 | ',
          style: TextStyle(color: Colors.grey, fontSize: 11),
        ),
        Text(
          member.relationship,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
} 