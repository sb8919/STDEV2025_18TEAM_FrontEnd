import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar/calendar_header.dart';
import '../widgets/calendar/calendar_grid.dart';
import '../widgets/calendar/calendar_week_days.dart';
import '../widgets/calendar/calendar_modal.dart';
import '../constants/app_colors.dart';
import '../models/health_record.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 25,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CalendarHeader(
                        focusedDate: provider.state.focusedDate,
                        onMonthChanged: (date) => provider.setFocusedDate(date),
                      ),
                      const CalendarWeekDays(),
                      const SizedBox(height: 10),
                      CalendarGrid(
                        focusedDate: provider.state.focusedDate,
                        selectedDate: provider.state.selectedDate,
                        records: provider.state.records,
                        onDateTap: (date, position) {
                          final records = provider.getRecordsForDate(date);
                          if (records.isNotEmpty) {
                            provider.setSelectedDate(date);
                            showDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              builder: (context) => CalendarModal(
                                date: date,
                                records: records,
                                position: position,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                _buildRecordsList(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecordsList(BuildContext context, CalendarProvider provider) {
    final targetDate = provider.state.selectedDate ?? DateTime.now();
    final records = provider.getRecordsForDate(targetDate);
    final dateFormat = DateFormat('M월 d일');
    final displayDate = dateFormat.format(targetDate);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$displayDate의 저장된 신호',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // 전체보기 기능 구현
                },
                child: Row(
                  children: [
                    Text(
                      '전체보기',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (records.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '저장된 신호가 없습니다.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (context, index) => _buildRecordItem(records[index]),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRecordItem(HealthRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.shortFormattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              // 더보기 메뉴 구현
            },
          ),
        ],
      ),
    );
  }
} 