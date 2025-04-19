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
            if (members.length > 1)
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
} 