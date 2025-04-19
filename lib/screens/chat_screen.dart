import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: const Center(
        child: Text(
          '메딧톡',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
} 