import 'package:flutter/material.dart';
import '../models/calendar_state.dart';
import '../models/health_record.dart';

class CalendarProvider extends ChangeNotifier {
  CalendarState _state = CalendarState(
    focusedDate: DateTime.now(),
    records: healthRecords,
  );

  CalendarState get state => _state;

  void setFocusedDate(DateTime date) {
    _state = _state.copyWith(focusedDate: date);
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    _state = _state.copyWith(selectedDate: date);
    notifyListeners();
  }

  void setRecords(List<HealthRecord> records) {
    _state = _state.copyWith(records: records);
    notifyListeners();
  }

  List<HealthRecord> getRecordsForDate(DateTime date) {
    return _state.records.where((record) => 
      record.date.year == date.year && 
      record.date.month == date.month && 
      record.date.day == date.day
    ).toList();
  }

  bool hasRecordsForDate(DateTime date) {
    return getRecordsForDate(date).isNotEmpty;
  }
} 