import 'package:flutter/material.dart';
import '../../../models/card_news.dart';

class NewsCard extends StatelessWidget {
  final CardNews news;

  const NewsCard({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                news.iconPath,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                news.title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
} 