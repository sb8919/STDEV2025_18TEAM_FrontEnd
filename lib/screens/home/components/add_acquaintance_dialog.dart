import 'package:flutter/material.dart';
import '../../../models/member.dart';

class AddAcquaintanceDialog extends StatefulWidget {
  final Function(Acquaintance) onAdd;

  const AddAcquaintanceDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddAcquaintanceDialog> createState() => _AddAcquaintanceDialogState();
}

class _AddAcquaintanceDialogState extends State<AddAcquaintanceDialog> {
  final _nameController = TextEditingController();
  final _relationshipController = TextEditingController();
  String _selectedSymptom = '편두통';
  double _symptomValue = 0.7;
  int _severityLevel = 2;

  final List<String> _symptoms = ['편두통', '불안감', '근육통', '어지러움', '불면증'];

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_nameController.text.isEmpty || _relationshipController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    final newAcquaintance = Acquaintance(
      name: _nameController.text,
      relationship: _relationshipController.text,
      imagePath: 'assets/images/charactor/medit_circle.png',
      healthMetrics: HealthMetrics(
        metrics: [
          MetricData(
            name: _selectedSymptom,
            value: _symptomValue,
            severityLevel: _severityLevel,
          ),
        ],
      ),
    );

    widget.onAdd(newAcquaintance);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '지인 추가',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '지인의 이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _relationshipController,
              decoration: const InputDecoration(
                labelText: '관계',
                hintText: '지인과의 관계를 입력하세요',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '주요 증상',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptoms.map((symptom) {
                return ChoiceChip(
                  label: Text(symptom),
                  selected: _selectedSymptom == symptom,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedSymptom = symptom;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              '증상 정도',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Slider(
              value: _symptomValue,
              onChanged: (value) {
                setState(() {
                  _symptomValue = value;
                  _severityLevel = value < 0.4 ? 1 : value < 0.7 ? 2 : 3;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '취소',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        TextButton(
          onPressed: _handleAdd,
          child: const Text(
            '추가',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
} 