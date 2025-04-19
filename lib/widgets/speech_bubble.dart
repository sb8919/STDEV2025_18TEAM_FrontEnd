import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String message;
  final double width;

  const SpeechBubble({
    super.key,
    required this.message,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 말풍선 꼬리
          Positioned(
            left: 30,
            top: -10,
            child: CustomPaint(
              size: const Size(20, 10),
              painter: BubbleTailPainter(color: const Color(0xFFA0A0A0)),
            ),
          ),
          // 말풍선 본체
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFA0A0A0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// 말풍선 꼬리를 그리는 CustomPainter
class BubbleTailPainter extends CustomPainter {
  final Color color;

  BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BubbleTailPainter oldDelegate) => color != oldDelegate.color;
} 