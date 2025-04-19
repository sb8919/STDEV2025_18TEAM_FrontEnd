import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/member.dart';

class EditRelationshipScreen extends StatefulWidget {
  final Acquaintance acquaintance;
  final Function(String)? onDelete;

  const EditRelationshipScreen({
    super.key,
    required this.acquaintance,
    this.onDelete,
  });

  @override
  State<EditRelationshipScreen> createState() => _EditRelationshipScreenState();
}

class _EditRelationshipScreenState extends State<EditRelationshipScreen> {
  late TextEditingController _nameController;
  late String _selectedRelationship;

  final List<String> _relationships = [
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
    _nameController = TextEditingController(text: widget.acquaintance.name);
    _selectedRelationship = _relationships.contains(widget.acquaintance.relationship)
        ? widget.acquaintance.relationship
        : _relationships[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateInfo() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해주세요')),
      );
      return;
    }
    Navigator.pop(context, {
      'name': _nameController.text,
      'relationship': _selectedRelationship,
    });
  }

  void _deleteAcquaintance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지인 삭제'),
        content: const Text('정말로 이 지인을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (widget.onDelete != null) {
                widget.onDelete!(_nameController.text);
              }
              Navigator.pop(context); // Close edit screen
            },
            child: const Text(
              '삭제',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '지인 정보',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: const SizedBox(),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '이름',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF394BF5)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '관계',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF394BF5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '저장하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: _deleteAcquaintance,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                  child: const Text(
                    '지인 정보 삭제하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 