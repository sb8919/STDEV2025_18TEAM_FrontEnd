import 'package:flutter/material.dart';

class PainIntensitySlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  final String? title;

  const PainIntensitySlider({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.title,
  });

  @override
  State<PainIntensitySlider> createState() => _PainIntensitySliderState();
}

class _PainIntensitySliderState extends State<PainIntensitySlider> {
  late double _value;
  final List<String> _intensityLabels = [
    '없음',
    '약간',
    '보통',
    '심함',
    '매우 심함',
  ];

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (widget.title != null)
          const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8.0,
            activeTrackColor: Colors.red[300],
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.red,
            overlayColor: Colors.red.withOpacity(0.1),
            valueIndicatorColor: Colors.red,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          child: Slider(
            value: _value,
            min: 0,
            max: 4,
            divisions: 4,
            label: _intensityLabels[_value.round()],
            onChanged: (value) {
              setState(() {
                _value = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _intensityLabels.length,
              (index) => Text(
                _intensityLabels[index],
                style: TextStyle(
                  fontSize: 12,
                  color: index == _value.round() ? Colors.red : Colors.grey,
                  fontWeight: index == _value.round() ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 