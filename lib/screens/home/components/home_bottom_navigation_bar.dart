import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/navigation/home.png',
            width: 24,
            height: 24,
            color: currentIndex == 0 ? AppColors.secondary : AppColors.secondary.withOpacity(0.5),
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/navigation/calendar.png',
            width: 24,
            height: 24,
            color: currentIndex == 1 ? AppColors.secondary : AppColors.secondary.withOpacity(0.5),
          ),
          label: '메딧달력',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/navigation/chat.png',
            width: 24,
            height: 24,
            color: currentIndex == 2 ? AppColors.secondary : AppColors.secondary.withOpacity(0.5),
          ),
          label: '메딧톡',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: AppColors.secondary,
      onTap: onTap,
    );
  }
} 