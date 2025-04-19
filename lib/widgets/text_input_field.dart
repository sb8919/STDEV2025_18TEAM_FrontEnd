import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String question;
  final String label_hint;
  final String type_assist;
  final TextEditingController controller;

  const TextInputField({
    super.key,
    required this.question,
    required this.label_hint,
    required this.type_assist,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: label_hint,
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF005BAC), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          type_assist,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
} 