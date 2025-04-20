import 'package:flutter/material.dart';
import 'package:stdev2025_18team_frontend/constants/app_colors.dart';
import '../models/member.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddFriendScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddFriend;

  const AddFriendScreen({
    super.key,
    required this.onAddFriend,
  });

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _searchResult;
  String? _myId;
  final int _maxLength = 20;  // 최대 글자 수 제한

  @override
  void initState() {
    super.initState();
    _loadMyId();
  }

  void _loadMyId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final decodedData = json.decode(userData);
      setState(() {
        _myId = decodedData['loginId'];
      });
    }
  }

  void _searchUser() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _searchResult = null;
    });

    try {
      final userData = await ApiService.searchUserById(_searchController.text);
      
      if (userData != null) {
        setState(() {
          _isLoading = false;
          _searchResult = {
            'nickname': userData['nickname'] ?? '',
            'relationship': '지인',
            'symptoms': List<String>.from(userData['usual_illness'] ?? []),
          };
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = '사용자를 찾을 수 없습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '오류가 발생했습니다: $e';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '메딧ID로 지인 추가',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: const SizedBox(),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: (_searchResult != null || _error != null) ? null : 150,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      maxLength: _maxLength,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _searchController.text.isEmpty ? Colors.grey[400] : Colors.grey[800],
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: '아이디를 입력하세요',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      onSubmitted: (_) => _searchUser(),
                    ),
                  ),
                  Text(
                    '${_searchController.text.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const Text(
                    ' / ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  Text(
                    '$_maxLength',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFEEEEEE),
              ),
              if (_myId != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0XFFF5F6FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '내 아이디',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF818283),
                        ),
                      ),
                      Text(
                        '$_myId',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFF818283),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (_searchResult != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _searchResult!['nickname'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _searchController.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onAddFriend(_searchResult!);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.purpple,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 