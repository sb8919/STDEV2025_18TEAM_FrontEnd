import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/member.dart';

class ProfileCard extends StatefulWidget {
  final Member member;
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool showAllProfiles;
  final VoidCallback onShowAllToggle;
  final Function(Member) onMemberUpdate;

  const ProfileCard({
    super.key,
    required this.member,
    required this.isExpanded,
    required this.onToggle,
    required this.showAllProfiles,
    required this.onShowAllToggle,
    required this.onMemberUpdate,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isEditing = false;
  late TextEditingController _nicknameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _symptomsController;
  late String _selectedRelationship;
  late bool _isMainProfile;
  late String _selectedGender;

  final List<String> _relationships = [
    '미성년 자녀',
    '가족',
    '부모',
    '자녀',
    '배우자',
    '형제/자매',
    '친척',
    '친구',
    '지인',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _nicknameController = TextEditingController(text: widget.member.nickname);
    _ageController = TextEditingController(text: widget.member.age.toString());
    _genderController = TextEditingController(text: widget.member.gender);
    _symptomsController = TextEditingController(text: widget.member.symptoms.join(', '));
    _selectedRelationship = widget.member.relationship;
    _isMainProfile = widget.member.isMainProfile;
    _selectedGender = widget.member.gender;
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Save changes
        _handleProfileUpdate();
      }
      _isEditing = !_isEditing;
      if (_isEditing) {
        _initializeControllers();
      }
    });
  }

  void _handleProfileUpdate() {
    if (_nicknameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _symptomsController.text.isEmpty) {
      return;
    }

    final updatedMember = Member(
      nickname: _nicknameController.text,
      gender: _selectedGender,
      age: int.tryParse(_ageController.text) ?? 0,
      symptoms: _symptomsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      relationship: _selectedRelationship,
      isMainProfile: _isMainProfile,
      acquaintances: widget.member.acquaintances,
      healthMetrics: widget.member.healthMetrics,
      loginId: widget.member.loginId,
      password: widget.member.password,
      ageRange: '${(int.tryParse(_ageController.text) ?? 0) ~/ 10 * 10}-${(int.tryParse(_ageController.text) ?? 0) ~/ 10 * 10 + 9}',
    );

    widget.onMemberUpdate(updatedMember);
    setState(() {
      _isEditing = false;
    });
  }

  Widget _buildProfileHeader() {
    return InkWell(
      onTap: widget.onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: widget.member.isMainProfile ? AppColors.primary : Colors.grey[300],
              child: Image.asset('assets/images/charactor/medit_circle.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.member.nickname,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '관계 | ${widget.member.relationship}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF868686),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.member.isMainProfile ? AppColors.primary : Colors.grey[300],
                border: widget.member.isMainProfile 
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              ),
              child: Icon(
                Icons.check,
                color: widget.member.isMainProfile ? Colors.white : Colors.grey[600],
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('닉네임', widget.member.nickname, _nicknameController),
          const SizedBox(height: 8),
          _buildInfoRow('관계', widget.member.relationship, null, isRelationship: true),
          const SizedBox(height: 8),
          _buildInfoRow('성별', widget.member.gender, _genderController),
          const SizedBox(height: 8),
          _buildInfoRow('나이', '만 ${widget.member.age}세', _ageController, suffix: '세'),
          const SizedBox(height: 8),
          _buildInfoRow('평소 질환', widget.member.symptoms.join(', '), _symptomsController, hint: '콤마(,)로 구분하여 입력'),
          const SizedBox(height: 8),
          if (_isEditing) ...[
            Row(
              children: [
                Text(
                  '대표계정으로 설정',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _isMainProfile,
                  onChanged: (value) {
                    setState(() {
                      _isMainProfile = value;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleEdit,
                child: Text(
                  _isEditing ? '저장하기' : '수정하기',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, TextEditingController? controller, {String? suffix, String? hint, bool isRelationship = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: _isEditing
              ? isRelationship
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRelationship,
                          isExpanded: true,
                          items: _relationships.map((String relationship) {
                            return DropdownMenuItem<String>(
                              value: relationship,
                              child: Text(relationship),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedRelationship = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  : TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        suffix: suffix != null ? Text(suffix) : null,
                        hintText: hint,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                    )
              : Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: widget.member.isMainProfile && !widget.showAllProfiles
            ? BorderRadius.circular(15)
            : null,
      ),
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
            child: _buildProfileHeader(),
          ),
          if (widget.isExpanded) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Colors.grey),
            ),
            _buildExpandedContent(),
          ],
        ],
      ),
    );
  }
} 