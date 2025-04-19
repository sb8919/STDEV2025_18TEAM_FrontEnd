import 'package:flutter/material.dart';

enum BodyPart {
  head,
  body,
  leftArm,
  rightArm,
  leftLeg,
  rightLeg,
  none
}

class BodyPartSelector extends StatefulWidget {
  final Function(BodyPart) onPartSelected;

  const BodyPartSelector({
    super.key,
    required this.onPartSelected,
  });

  @override
  State<BodyPartSelector> createState() => _BodyPartSelectorState();
}

class _BodyPartSelectorState extends State<BodyPartSelector> {
  BodyPart selectedPart = BodyPart.none;

  String _getBodyPartName(BodyPart part) {
    switch (part) {
      case BodyPart.head:
        return '머리';
      case BodyPart.body:
        return '몸통';
      case BodyPart.leftArm:
        return '왼팔';
      case BodyPart.rightArm:
        return '오른팔';
      case BodyPart.leftLeg:
        return '왼다리';
      case BodyPart.rightLeg:
        return '오른다리';
      case BodyPart.none:
        return '선택된 부위 없음';
    }
  }

  void _selectPart(BodyPart part) {
    setState(() {
      selectedPart = part;
    });
    widget.onPartSelected(part);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(220, 260),
                  painter: BodyPainter(selectedPart: selectedPart),
                ),

                // Head
                Positioned(
                  top: 10,
                  child: GestureDetector(
                    onTap: () => _selectPart(BodyPart.head),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // Body
                Positioned(
                  top: 70,
                  child: GestureDetector(
                    onTap: () => _selectPart(BodyPart.body),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // Left Arm
                Positioned(
                  top: 75,
                  left: 30,
                  child: GestureDetector(
                    onTap: () => _selectPart(BodyPart.leftArm),
                    child: Container(
                      width: 50,
                      height: 15,
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // Right Arm
                Positioned(
                  top: 75,
                  right: 30,
                  child: GestureDetector(
                    onTap: () => _selectPart(BodyPart.rightArm),
                    child: Container(
                      width: 50,
                      height: 15,
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // Left Leg
                Positioned(
                  top: 130,
                  left: 85,
                  child: GestureDetector(
                    onTap: () => _selectPart(BodyPart.leftLeg),
                    child: Container(
                      width: 15,
                      height: 50,
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // Right Leg
                Positioned(
                  top: 130,
                  right: 85,
                  child: GestureDetector(
                    onTap: () => _selectPart(BodyPart.rightLeg),
                    child: Container(
                      width: 15,
                      height: 50,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getBodyPartName(selectedPart),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyPainter extends CustomPainter {
  final BodyPart selectedPart;

  BodyPainter({required this.selectedPart});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.fill;

    Paint getPaint(BodyPart part) =>
        selectedPart == part ? selectedPaint : paint;

    // Head
    canvas.drawCircle(
      Offset(size.width / 2, 40),
      30,
      getPaint(BodyPart.head),
    );

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width / 2 - 30, 70, 60, 60),
      const Radius.circular(10),
    );
    canvas.drawRRect(bodyRect, getPaint(BodyPart.body));

    // Left Arm
    final leftArm = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width / 2 - 80, 75, 50, 15),
      const Radius.circular(6),
    );
    canvas.drawRRect(leftArm, getPaint(BodyPart.leftArm));

    // Right Arm
    final rightArm = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width / 2 + 30, 75, 50, 15),
      const Radius.circular(6),
    );
    canvas.drawRRect(rightArm, getPaint(BodyPart.rightArm));

    // Left Leg
    final leftLeg = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width / 2 - 25, 130, 15, 50),
      const Radius.circular(7),
    );
    canvas.drawRRect(leftLeg, getPaint(BodyPart.leftLeg));

    // Right Leg
    final rightLeg = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width / 2 + 10, 130, 15, 50),
      const Radius.circular(7),
    );
    canvas.drawRRect(rightLeg, getPaint(BodyPart.rightLeg));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
