import 'package:flutter/material.dart';

class PainIntensitySlider extends StatefulWidget {
  final Function(double) onChanged;
  final double value;

  const PainIntensitySlider({
    super.key,
    required this.onChanged,
    required this.value,
  });

  @override
  State<PainIntensitySlider> createState() => _PainIntensitySliderState();
}

class _PainIntensitySliderState extends State<PainIntensitySlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '약함',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Text(
                '심함',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF394BF5),
              inactiveTrackColor: Colors.grey[200],
              thumbColor: const Color(0xFF394BF5),
              overlayColor: const Color(0xFF394BF5).withOpacity(0.2),
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8.0,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 16.0,
              ),
            ),
            child: Slider(
              value: widget.value,
              min: 0.0,
              max: 10.0,
              divisions: 10,
              label: widget.value.toStringAsFixed(1),
              onChanged: widget.onChanged,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '통증 강도: ${widget.value.toStringAsFixed(1)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF394BF5),
            ),
          ),
        ],
      ),
    );
  }
} 