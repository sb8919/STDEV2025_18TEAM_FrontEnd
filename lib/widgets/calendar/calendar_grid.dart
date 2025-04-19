import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/health_record.dart';
import 'calendar_day_cell.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime? selectedDate;
  final List<HealthRecord> records;
  final Function(DateTime, Offset) onDateTap;

  const CalendarGrid({
    super.key,
    required this.focusedDate,
    required this.selectedDate,
    required this.records,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
        final firstWeekday = firstDayOfMonth.weekday;
        final prevMonthDays = (firstWeekday == 7 ? 0 : firstWeekday);
        final day = index - prevMonthDays + 1;
        
        if (day < 1 || day > DateUtils.getDaysInMonth(focusedDate.year, focusedDate.month)) {
          return const SizedBox();
        }

        final date = DateTime(focusedDate.year, focusedDate.month, day);
        final isToday = DateTime.now().year == date.year &&
            DateTime.now().month == date.month &&
            DateTime.now().day == date.day;
        final isFutureDate = date.isAfter(DateTime.now());
        final isSelected = selectedDate?.year == date.year &&
            selectedDate?.month == date.month &&
            selectedDate?.day == date.day;
        final dateRecords = records.where((record) => 
          record.date.year == date.year && 
          record.date.month == date.month && 
          record.date.day == date.day
        ).toList();

        return CalendarDayCell(
          date: date,
          isToday: isToday,
          isFutureDate: isFutureDate,
          isSelected: isSelected,
          records: dateRecords,
          onTap: onDateTap,
        );
      },
    );
  }
} 