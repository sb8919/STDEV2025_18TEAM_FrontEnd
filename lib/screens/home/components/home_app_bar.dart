import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import 'week_calendar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String nickname;
  final DateTime selectedDate;
  final DateTime startOfWeek;
  final List<String> weekDays;
  final Function(DateTime) onDateSelected;

  const HomeAppBar({
    super.key,
    required this.nickname,
    required this.selectedDate,
    required this.startOfWeek,
    required this.weekDays,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(185),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$nickname 님,',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '오늘 하루 어떠셨나요?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
            WeekCalendar(
              selectedDate: selectedDate,
              startOfWeek: startOfWeek,
              onDateSelected: onDateSelected,
              weekDays: weekDays,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(185);
} 