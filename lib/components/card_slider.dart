import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

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
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.cardData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final data = widget.cardData[index];
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
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.cardData.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage
                        ? AppColors.primary
                        : AppColors.textWhite.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: Text(
              widget.cardData[_currentPage]['title']!,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: AppColors.shadow,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 