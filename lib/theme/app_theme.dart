import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // 배경
  static const Color background    = Color(0xFFFAF6F1); // 따뜻한 아이보리 크림
  static const Color parchment     = Color(0xFFF3ECE3); // 카드 배경

  // 포인트
  static const Color dustyRose     = Color(0xFFC9A090); // 더스티 로즈 (primary)
  static const Color dustyRoseLight= Color(0xFFDFC4B8); // 연한 더스티 로즈
  static const Color gold          = Color(0xFFC8A96E); // 골드 장식선

  // 그린
  static const Color sage          = Color(0xFF8A9E84); // 세이지 그린
  static const Color sageLight     = Color(0xFFBDD0B7);
  static const Color sageBg        = Color(0xFFEBF2E9);

  // 텍스트
  static const Color textDark      = Color(0xFF6B5044); // 브라운 다크
  static const Color textMedium    = Color(0xFF8C6E63); // 브라운 미드
  static const Color textLight     = Color(0xFFB8A89E); // 워밍 그레이

  // 테두리 / 구분선
  static const Color border        = Color(0xFFE8DDD5);
  static const Color divider       = Color(0xFFE8DDD5);

  // 하위 호환 (기존 코드 컴파일 유지)
  static const Color primary       = dustyRose;
  static const Color primaryLight  = dustyRoseLight;
  static const Color cardBackground= parchment;
  static const Color cardBorder    = border;
  static const Color quoteBackground= Color(0xFFF3ECE3);
  static const Color textHint      = textLight;
}

/// Playfair Display — 번들 폰트 우선, 네트워크 폴백
class AppFonts {
  static TextStyle playfair({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    Color color = AppColors.textDark,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'PlayfairDisplay',
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.dustyRose,
        secondary: AppColors.sage,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
