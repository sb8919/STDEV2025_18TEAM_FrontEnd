import 'package:flutter/material.dart';
import '../models/health_record.dart';

class CalendarState {
  final DateTime focusedDate;
  final DateTime? selectedDate;
  final List<HealthRecord> records;

  CalendarState({
    required this.focusedDate,
    this.selectedDate,
    required this.records,
  });

  CalendarState copyWith({
    DateTime? focusedDate,
    DateTime? selectedDate,
    List<HealthRecord>? records,
  }) {
    return CalendarState(
      focusedDate: focusedDate ?? this.focusedDate,
      selectedDate: selectedDate ?? this.selectedDate,
      records: records ?? this.records,
    );
  }
} 