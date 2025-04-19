import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/member_data.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  List<Member> _members = [];
  bool _isExpanded = false;
  Member? _selectedMember;
  bool _isEditing = false;
  late TextEditingController _nicknameController;
  late TextEditingController _ageController;
  late String _selectedGender;
  late List<String> _selectedSymptoms;
  late String _selectedRelationship;

  final List<String> _relationships = [
    '본인',
    '미성년 자녀',
    '부 (아버지)',
    '모 (어머니)',
    '배우자 (남편/아내)',
    '자녀 (아들/딸)',
    '형제자매',
    '친구',
    '직장 동료 / 룸메이트',
  ];

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nicknameController = TextEditingController();
    _ageController = TextEditingController();
    _selectedGender = '';
    _selectedSymptoms = [];
    _selectedRelationship = '미성년 자녀';
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    if (members.isEmpty) {
      final defaultMember = Member(
        name: '사용자 1',
        nickname: '사용자 1',
        relationship: '본인',
        gender: '여',
        age: 25,
        symptoms: ['두통', '어지움'],
        hasProfile: true,
        isMainProfile: true,
        imagePath: 'assets/images/profile/default.png',
      );
      members.add(defaultMember);
    }
    
    setState(() {
      _members = members.where((member) => member.hasProfile).toList();
    });
  }

  void _handleAddProfile() {
    setState(() {
      _selectedMember = null;
      _isEditing = true;
      _initializeControllers();
    });
  }

  void _saveProfile() {
    if (_selectedMember == null) {
      final newMember = Member(
        name: _nicknameController.text,
        nickname: _nicknameController.text,
        relationship: _selectedRelationship,
        gender: _selectedGender,
        age: int.tryParse(_ageController.text) ?? 0,
        symptoms: _selectedSymptoms,
        hasProfile: true,
        isMainProfile: members.isEmpty,
        imagePath: 'assets/images/profile/default.png',
      );
      setState(() {
        members.add(newMember);
        _loadMembers();
        _isEditing = false;
        _selectedMember = null;
      });
    } else {
      final updatedMember = _selectedMember!.copyWith(
        nickname: _nicknameController.text,
        gender: _selectedGender,
        age: int.tryParse(_ageController.text) ?? 0,
        symptoms: _selectedSymptoms,
      );
      
      setState(() {
        final index = members.indexOf(_selectedMember!);
        if (index != -1) {
          members[index] = updatedMember;
        }
        _loadMembers();
        _isEditing = false;
        _selectedMember = null;
      });
    }
  }

  void _selectMember(Member member) {
    setState(() {
      if (_selectedMember == member) {
        _selectedMember = null;
        _isEditing = false;
      } else {
        _selectedMember = member;
        _isEditing = false;
        _nicknameController.text = member.nickname;
        _ageController.text = member.age.toString();
        _selectedGender = member.gender;
        _selectedSymptoms = List.from(member.symptoms);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._members.map((member) => Column(
            children: [
              _buildProfileCard(
                name: member.nickname,
                role: member.relationship,
                isMain: member.isMainProfile,
                member: member,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: Colors.grey[300]),
              ),
            ],
          )).toList(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleAddProfile,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '프로필 추가하기',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isEditing && _selectedMember == null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Colors.grey[300]),
                ),
                _buildEditForm(),
              ],
            ),
          if (!_isEditing || _selectedMember != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Colors.grey[300]),
            ),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String name,
    required String role,
    required bool isMain,
    required Member member,
  }) {
    final isSelected = _selectedMember == member;
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectMember(member),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isMain ? AppColors.primary : Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: isMain ? Colors.white : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '관계 | $role',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isMain ? AppColors.primary : Colors.grey[300],
                      border: isMain 
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                    ),
                    child: Icon(
                      Icons.check,
                      color: isMain ? Colors.white : Colors.grey[600],
                      size: 16,
                    ),
                  ),
                  if (isSelected && !_isEditing)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: Text(
                        '수정하기',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (isSelected && _isEditing)
          _buildDetailView(member),
      ],
    );
  }

  Widget _buildDetailView(Member member) {
    bool isMain = member.isMainProfile;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nicknameController,
                  enabled: _isEditing,
                  decoration: InputDecoration(
                    labelText: '닉네임',
                    border: _isEditing ? null : InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: member.gender),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: '성별',
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_isEditing) ...[
                _buildGenderOption('남'),
                const SizedBox(width: 16),
                _buildGenderOption('여'),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ageController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '나이',
                    suffixText: '세',
                    border: _isEditing ? null : InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('평소 질환', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 4),
          if (_isEditing)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSymptomChip('두통'),
                _buildSymptomChip('어지움'),
                _buildSymptomChip('허리 통증'),
                _buildSymptomChip('어깨 통증'),
              ],
            )
          else
            Text(
              member.symptoms.join(', '),
              style: const TextStyle(fontSize: 14),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '대표 사용자로 설정',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isMain,
                onChanged: (value) {
                  if (_isEditing) {
                    setState(() {
                      if (value) {
                        for (var i = 0; i < members.length; i++) {
                          if (members[i].isMainProfile) {
                            members[i] = members[i].copyWith(isMainProfile: false);
                          }
                        }
                        final index = members.indexOf(member);
                        if (index != -1) {
                          members[index] = member.copyWith(isMainProfile: true);
                          _selectedMember = members[index];
                        }
                      } else {
                        if (members.length > 1) {
                          final otherMembers = members.where((m) => m != member).toList();
                          if (otherMembers.isNotEmpty) {
                            final newMainIndex = members.indexOf(otherMembers.first);
                            members[newMainIndex] = otherMembers.first.copyWith(isMainProfile: true);
                          }
                        }
                        final index = members.indexOf(member);
                        if (index != -1) {
                          members[index] = member.copyWith(isMainProfile: false);
                          _selectedMember = members[index];
                        }
                      }
                    });
                  }
                },
                activeColor: AppColors.primary,
              ),
              const Spacer(),
              if (_isEditing) ...[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _selectedMember = null;
                    });
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _saveProfile,
                  child: Text(
                    '저장',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: '닉네임',
              hintText: '닉네임을 입력하세요',
            ),
          ),
          const SizedBox(height: 16),
          const Text('관계', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
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
          ),
          const SizedBox(height: 16),
          const Text('성별', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildGenderOption('남'),
              const SizedBox(width: 16),
              _buildGenderOption('여'),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '나이',
              hintText: '나이를 입력하세요',
              suffixText: '세',
            ),
          ),
          const SizedBox(height: 16),
          const Text('평소 질환', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSymptomChip('두통'),
              _buildSymptomChip('어지움'),
              _buildSymptomChip('허리 통증'),
              _buildSymptomChip('어깨 통증'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _selectedMember = null;
                  });
                },
                child: Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _saveProfile,
                child: Text(
                  '저장',
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

  Widget _buildGenderOption(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSymptomChip(String symptom) {
    final isSelected = _selectedSymptoms.contains(symptom);
    return FilterChip(
      selected: isSelected,
      label: Text(symptom),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedSymptoms.add(symptom);
          } else {
            _selectedSymptoms.remove(symptom);
          }
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }
} 