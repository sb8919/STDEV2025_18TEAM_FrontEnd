import 'package:flutter/material.dart';
import '../../../models/member.dart';
import 'profile_card.dart';

class ProfileSection extends StatefulWidget {
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
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  void _showAddProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String nickname = '';
        String relationship = '미성년 자녀';  // 기본값을 '미성년 자녀'로 설정
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
                  items: const [
                    '미성년 자녀',  // 첫 번째 항목으로 이동
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
                  widget.onMemberUpdate(newMember);
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

  Widget _buildAddProfileButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAddProfileDialog(context),
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
                  color: Color(0XFF394BF5),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.members.isEmpty) {
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
            _buildExpandCollapseButton(),
          ],
        ),
      );
    }

    final mainProfile = widget.members.firstWhere((member) => member.isMainProfile);
    final otherProfiles = widget.members.where((member) => !member.isMainProfile).toList();

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
                borderRadius: !widget.isExpanded
                    ? BorderRadius.circular(15)
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
              ),
              child: ProfileCard(
                member: mainProfile,
                isExpanded: widget.selectedMember == mainProfile,
                onToggle: () => widget.onToggleMemberDetail(mainProfile),
                showAllProfiles: widget.isExpanded,
                onShowAllToggle: widget.onToggleExpanded,
                onMemberUpdate: (updatedMember) {
                  // 메인 프로필 업데이트 시 전체 멤버 목록에서 해당 멤버를 찾아 업데이트
                  final index = widget.members.indexWhere((m) => m.isMainProfile);
                  if (index != -1) {
                    widget.onMemberUpdate(updatedMember);
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Color(0xFFC3CCF5)),
            ),
            if (widget.isExpanded) ...[
              ...otherProfiles.map((member) => Column(
                children: [
                  ProfileCard(
                    member: member,
                    isExpanded: widget.selectedMember == member,
                    onToggle: () => widget.onToggleMemberDetail(member),
                    showAllProfiles: widget.isExpanded,
                    onShowAllToggle: widget.onToggleExpanded,
                    onMemberUpdate: widget.onMemberUpdate,
                  ),
                  if (member != otherProfiles.last)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 0.5, color: Color(0xFFC3CCF5)),
                    ),
                ],
              )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 0.5, color: Color(0xFFC3CCF5)),
              ),
              _buildAddProfileButton(),
            ],
            _buildExpandCollapseButton(),
          ],
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
        onTap: widget.onToggleExpanded,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Icon(
            widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
} 