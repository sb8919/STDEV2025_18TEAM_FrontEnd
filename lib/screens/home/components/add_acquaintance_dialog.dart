import 'package:flutter/material.dart';
import '../../../models/member.dart';

class AddAcquaintanceDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddAcquaintance;

  const AddAcquaintanceDialog({
    super.key,
    required this.onAddAcquaintance,
  });

  @override
  State<AddAcquaintanceDialog> createState() => _AddAcquaintanceDialogState();
}

class _AddAcquaintanceDialogState extends State<AddAcquaintanceDialog> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = '남';
  String _selectedRelationship = '지인';

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

  void _handleSubmit() {
    if (_nicknameController.text.isEmpty || _ageController.text.isEmpty) {
      return;
    }

    final newAcquaintance = {
      'nickname': _nicknameController.text,
      'relationship': _selectedRelationship,
      'age': int.tryParse(_ageController.text) ?? 25,
      'gender': _selectedGender,
    };

    widget.onAddAcquaintance(newAcquaintance);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '지인 추가하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '나이',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: '성별',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '남', child: Text('남자')),
                DropdownMenuItem(value: '여', child: Text('여자')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedGender = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRelationship,
              decoration: const InputDecoration(
                labelText: '관계',
                border: OutlineInputBorder(),
              ),
              items: _relationships.map((relationship) {
                return DropdownMenuItem(
                  value: relationship,
                  child: Text(relationship),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRelationship = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('추가하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 