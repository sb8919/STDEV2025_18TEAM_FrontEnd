import 'package:flutter/material.dart';
import 'member_screen.dart';
import 'profile_screen.dart';
import 'card_news_screen.dart';
import '../components/card_slider.dart';
import '../constants/card_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  final List<Widget> _screens = [
    const MemberScreen(),
    const ProfileScreen(),
    const CardNewsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/logo.png', height: 30),
            ),
            Center(
              child: Image.asset('assets/text_logo.png', height: 24),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CardSlider(cardData: cardData),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab(0, '구성원'),
                _buildTab(1, '프로필 설정'),
                _buildTab(2, '카드뉴스'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 0,
            ),
          ),
          Expanded(
            child: _screens[_selectedTab],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '메딧달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '메딧톡',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF005BAC),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? const Color(0xFF5A42F8) : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

