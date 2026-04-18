import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloversLogo extends StatelessWidget {
  final double fontSize;

  const FloversLogo({super.key, this.fontSize = 22});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          letterSpacing: 5,
          color: AppColors.textDark,
        ),
        children: const [
          TextSpan(text: 'F'),
          TextSpan(
            text: 'LOVE',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.w600,
              color: AppColors.dustyRose,
              letterSpacing: 5,
            ),
          ),
          TextSpan(text: 'RS'),
        ],
      ),
    );
  }
}
