import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarHeader extends StatefulWidget {
  final DateTime focusedDate;
  final Function(DateTime) onMonthChanged;

  const CalendarHeader({
    super.key,
    required this.focusedDate,
    required this.onMonthChanged,
  });

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _loadUserNickname();
  }

  Future<void> _loadUserNickname() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final decodedData = json.decode(userData);
      setState(() {
        _nickname = decodedData['nickname'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logos/logo_nonback.png',
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    '$_nickname 님,',
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
                'assets/images/charactor/stand_medit.png',
                width: 110,
                height: 130,
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
                  widget.onMonthChanged(DateTime(widget.focusedDate.year, widget.focusedDate.month - 1, 1));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.focusedDate.month}',
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
                  widget.onMonthChanged(DateTime(widget.focusedDate.year, widget.focusedDate.month + 1, 1));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
} 