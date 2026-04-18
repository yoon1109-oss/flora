import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/database_helper.dart';
import '../widgets/flovers_logo.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _rotation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      final dbHelper = DatabaseHelper();
      final defaultFlower = await dbHelper.getFirstFlower();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              MainScreen(defaultFlowerName: defaultFlower?.name ?? ''),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _rotation,
              child: Icon(
                Icons.local_florist,
                size: 72,
                color: AppColors.dustyRose,
              ),
            ),
            const SizedBox(height: 28),
            FadeTransition(
              opacity: _fadeIn,
              child: const FloversLogo(fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}
