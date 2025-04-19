import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CalendarWeekDays extends StatelessWidget {
  const CalendarWeekDays({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['일', '월', '화', '수', '목', '금', '토'].map((day) {
          final isWeekend = day == '일' || day == '토';
          return SizedBox(
            width: 30,
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isWeekend ? Colors.red : AppColors.textSecondary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 