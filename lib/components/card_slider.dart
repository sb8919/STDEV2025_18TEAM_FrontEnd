import 'package:flutter/material.dart';

class CardSlider extends StatefulWidget {
  final List<Map<String, String>> cardData;

  const CardSlider({
    super.key,
    required this.cardData,
  });

  @override
  State<CardSlider> createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          _buildPageView(),
          _buildPageIndicator(),
          _buildTitle(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return Positioned.fill(
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.cardData.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildCard(widget.cardData[index]);
        },
      ),
    );
  }

  Widget _buildCard(Map<String, String> data) {
    return Card(
      margin: EdgeInsets.zero,
      child: ClipRRect(
        child: Image.asset(
          data['image']!,
          width: double.infinity,
          height: 260,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.cardData.length,
          (index) => _buildIndicatorDot(index),
        ),
      ),
    );
  }

  Widget _buildIndicatorDot(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == _currentPage
            ? const Color(0xFF5A42F8)
            : Colors.white.withOpacity(0.5),
      ),
    );
  }

  Widget _buildTitle() {
    return Positioned(
      bottom: 50,
      left: 20,
      child: Text(
        widget.cardData[_currentPage]['title']!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
} 