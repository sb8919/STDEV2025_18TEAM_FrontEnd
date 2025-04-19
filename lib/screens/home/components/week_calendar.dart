import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime startOfWeek;
  final Function(DateTime) onDateSelected;
  final List<String> weekDays;

  const WeekCalendar({
    super.key,
    required this.selectedDate,
    required this.startOfWeek,
    required this.onDateSelected,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  onDateSelected(startOfWeek.subtract(const Duration(days: 7)));
                },
              ),
              Text(
                '${startOfWeek.month}월',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  onDateSelected(startOfWeek.add(const Duration(days: 7)));
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final date = startOfWeek.add(Duration(days: index));
            final isToday = date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day;
            final isSelected = date.year == selectedDate.year &&
                date.month == selectedDate.month &&
                date.day == selectedDate.day;

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Text(
                      weekDays[date.weekday % 7],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppColors.primary : date.weekday % 7 == 0 ? Colors.red : Colors.black54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                            color: isSelected || isToday ? AppColors.primary : date.weekday % 7 == 0 ? Colors.red : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (isToday)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
} 