import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

String getProfileImagePath(String gender, int age) {
  if (age >= 60) {
    return gender == '남' ? 'assets/images/charactor/age/60m.png' : 'assets/images/charactor/age/60g.png';
  } else if (age >= 40 && age <= 59) {
    return gender == '남' ? 'assets/images/charactor/age/4050m.png' : 'assets/images/charactor/age/4050g.png';
  } else if (age >= 30 && age <= 39) {
    return gender == '남' ? 'assets/images/charactor/age/30m.png' : 'assets/images/charactor/age/30g.png';
  } else if (age >= 20 && age <= 29) {
    return gender == '남' ? 'assets/images/charactor/age/20m.png' : 'assets/images/charactor/age/20g.png';
  } else if (age >= 10 && age <= 19) {
    return gender == '남' ? 'assets/images/charactor/age/10m.png' : 'assets/images/charactor/age/10g.png';
  }
  return 'assets/images/charactor/medit_circle.png';
}

Widget buildProfileCircle(String gender, int age, {double size = 46}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.thirdColor,
    ),
    child: ClipOval(
      child: Image.asset(
        getProfileImagePath(gender, age),
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    ),
  );
} 