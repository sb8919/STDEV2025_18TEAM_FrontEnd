import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/health_record.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isFutureDate;
  final bool isSelected;
  final List<HealthRecord> records;
  final Function(DateTime, Offset) onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isToday,
    required this.isFutureDate,
    required this.isSelected,
    required this.records,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isWeekend = date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;
    final hasRecords = records.isNotEmpty;

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        if (!isFutureDate && hasRecords) {
          onTap(date, details.globalPosition);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isFutureDate
                    ? Colors.grey.withOpacity(0.5)
                    : isSelected
                        ? Colors.white
                        : isToday
                            ? Colors.purple
                            : isWeekend
                                ? Colors.red
                                : AppColors.textPrimary,
              ),
            ),
            if (hasRecords && !isFutureDate)
              Positioned(
                bottom: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: records.take(3).map((record) {
                    return Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white 
                            : _getTypeColor(record.type),
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    final Map<String, Color> typeColors = {
      '통증': Colors.red,
      '정기검진': Colors.blue,
      '알레르기': Colors.green,
      '스트레스': Colors.purple,
      '운동': Colors.orange,
      '소화기': Colors.teal,
      '피로': Colors.brown,
    };
    return typeColors[type] ?? Colors.grey;
  }
} 