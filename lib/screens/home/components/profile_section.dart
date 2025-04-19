import 'package:flutter/material.dart';
import '../../../models/member.dart';
import 'profile_card.dart';

class ProfileSection extends StatelessWidget {
  final List<Member> members;
  final Member? selectedMember;
  final bool isExpanded;
  final Function(Member) onMemberUpdate;
  final Function(Member) onToggleMemberDetail;
  final VoidCallback onToggleExpanded;
  final VoidCallback onAddProfile;

  const ProfileSection({
    super.key,
    required this.members,
    required this.selectedMember,
    required this.isExpanded,
    required this.onMemberUpdate,
    required this.onToggleMemberDetail,
    required this.onToggleExpanded,
    required this.onAddProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildAddProfileButton(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Colors.grey),
            ),
            _buildExpandCollapseButton(),
          ],
        ),
      );
    }

    final mainProfile = members.firstWhere((member) => member.isMainProfile);
    final otherProfiles = members.where((member) => !member.isMainProfile).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: !isExpanded
                    ? BorderRadius.circular(15)
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
              ),
              child: ProfileCard(
                member: mainProfile,
                isExpanded: selectedMember == mainProfile,
                onToggle: () => onToggleMemberDetail(mainProfile),
                showAllProfiles: isExpanded,
                onShowAllToggle: onToggleExpanded,
                onMemberUpdate: onMemberUpdate,
              ),
            ),
            if (isExpanded) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: Colors.grey),
              ),
              ...otherProfiles.map((member) => Column(
                children: [
                  ProfileCard(
                    member: member,
                    isExpanded: selectedMember == member,
                    onToggle: () => onToggleMemberDetail(member),
                    showAllProfiles: isExpanded,
                    onShowAllToggle: onToggleExpanded,
                    onMemberUpdate: onMemberUpdate,
                  ),
                  if (member != otherProfiles.last)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Colors.grey),
                    ),
                ],
              )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: Colors.grey),
              ),
              _buildAddProfileButton(),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Colors.grey),
            ),
            _buildExpandCollapseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProfileButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAddProfile,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '프로필 추가하기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  color: Color(0xFFA9A9A9),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandCollapseButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: GestureDetector(
        onTap: onToggleExpanded,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _showAddProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String nickname = '';
        String relationship = '가족';
        String gender = '여';
        String age = '';
        String symptoms = '';

        return AlertDialog(
          title: const Text('프로필 추가하기'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: '닉네임',
                    hintText: '닉네임을 입력하세요',
                  ),
                  onChanged: (value) => nickname = value,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: relationship,
                  decoration: const InputDecoration(
                    labelText: '관계',
                  ),
                  items: [
                    '가족',
                    '부모',
                    '자녀',
                    '배우자',
                    '형제/자매',
                    '친척',
                    '친구',
                    '지인',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      relationship = newValue;
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(
                    labelText: '성별',
                  ),
                  items: ['남', '여'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      gender = newValue;
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '나이',
                    hintText: '나이를 입력하세요',
                    suffixText: '세',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => age = value,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '증상',
                    hintText: '증상을 쉼표로 구분하여 입력하세요',
                  ),
                  onChanged: (value) => symptoms = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (nickname.isNotEmpty && relationship.isNotEmpty && age.isNotEmpty) {
                  final newMember = Member(
                    nickname: nickname,
                    relationship: relationship,
                    gender: gender,
                    age: int.tryParse(age) ?? 0,
                    symptoms: symptoms.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    isMainProfile: false,
                    acquaintances: [],
                    healthMetrics: HealthMetrics(metrics: []),
                    loginId: 'user${DateTime.now().millisecondsSinceEpoch}',
                    password: 'defaultPassword',
                    ageRange: '${(int.tryParse(age) ?? 0) ~/ 10 * 10}-${(int.tryParse(age) ?? 0) ~/ 10 * 10 + 9}',
                  );
                  onMemberUpdate(newMember);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }
} 