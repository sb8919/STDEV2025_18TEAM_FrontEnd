import 'package:flutter/material.dart';
import '../constants/member_data.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Member? _selectedMember;
  bool _isEditing = false;
  late TextEditingController _nicknameController;
  late TextEditingController _ageController;
  late String _selectedGender;
  late List<String> _selectedSymptoms;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (_selectedMember != null) {
      _nicknameController = TextEditingController(text: _selectedMember!.nickname);
      _ageController = TextEditingController(text: _selectedMember!.age.toString());
      _selectedGender = _selectedMember!.gender;
      _selectedSymptoms = List.from(_selectedMember!.symptoms);
    } else {
      _nicknameController = TextEditingController();
      _ageController = TextEditingController();
      _selectedGender = '';
      _selectedSymptoms = [];
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_selectedMember == null) return;

    final updatedMember = _selectedMember!.copyWith(
      nickname: _nicknameController.text,
      gender: _selectedGender,
      age: int.tryParse(_ageController.text) ?? 0,
      symptoms: _selectedSymptoms,
      hasProfile: true,
    );
    
    setState(() {
      final index = members.indexOf(_selectedMember!);
      if (index != -1) {
        members[index] = updatedMember;
        _selectedMember = updatedMember;
      }
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...members.map((member) => _buildMemberCard(member)).toList(),
        ],
      ),
    );
  }

  Widget _buildMemberCard(Member member) {
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
                if (_selectedMember == member) {
                  _selectedMember = null;
                  _isEditing = false;
                } else {
                  _selectedMember = member;
                  _isEditing = false;
                  _initializeControllers();
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Image.asset(
                    member.imagePath,
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '관계 | ${member.relationship}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (member.isMainProfile)
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
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
                  if (isSelected && _isEditing)
                    TextButton(
                      onPressed: _saveProfile,
                      child: Text(
                        '저장하기',
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
          if (isSelected) ...[
            if (_isEditing)
              _buildEditForm()
            else
              _buildDetailView(),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    if (_selectedMember == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('닉네임', _selectedMember!.nickname),
          const SizedBox(height: 8),
          _buildDetailItem('성별', _selectedMember!.gender),
          const SizedBox(height: 8),
          _buildDetailItem('나이', '${_selectedMember!.age}세'),
          const SizedBox(height: 8),
          _buildDetailItem('평소 질환', _selectedMember!.symptoms.join(', ')),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
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
            children: [
              const Text('메인 프로필로 설정', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 10),
              Switch(
                value: _selectedMember?.isMainProfile ?? false,
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      // 기존 메인 프로필 해제
                      final mainProfileIndex = members.indexWhere((m) => m.isMainProfile);
                      if (mainProfileIndex != -1) {
                        members[mainProfileIndex] = members[mainProfileIndex].copyWith(isMainProfile: false);
                      }
                    }
                    // 현재 멤버를 메인 프로필로 설정
                    final currentIndex = members.indexOf(_selectedMember!);
                    if (currentIndex != -1) {
                      members[currentIndex] = members[currentIndex].copyWith(isMainProfile: value);
                      _selectedMember = members[currentIndex];
                    }
                  });
                },
                activeColor: AppColors.primary,
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