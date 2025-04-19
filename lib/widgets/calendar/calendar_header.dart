import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDate;
  final Function(DateTime) onMonthChanged;

  const CalendarHeader({
    super.key,
    required this.focusedDate,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logos/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    '닉네임 님,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '이번 달의 건강 신호를 살펴볼까요?',
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/charactor/medit.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  onMonthChanged(DateTime(focusedDate.year, focusedDate.month - 1, 1));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${focusedDate.month}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    '월',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  onMonthChanged(DateTime(focusedDate.year, focusedDate.month + 1, 1));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
} 