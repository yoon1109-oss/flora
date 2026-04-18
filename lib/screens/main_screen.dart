import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'flower_detail_screen.dart';
import 'favorites_screen.dart';

class MainScreen extends StatefulWidget {
  final String defaultFlowerName;

  const MainScreen({super.key, required this.defaultFlowerName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _favoritesKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: FlowerDetailScreen(
                initialFlowerName: widget.defaultFlowerName),
          ),
          if (_selectedIndex == 1)
            FavoritesScreen(key: ValueKey(_favoritesKey)),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 1) _favoritesKey++;
            setState(() => _selectedIndex = index);
          },
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.dustyRose,
          unselectedItemColor: AppColors.textLight,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist_outlined, size: 22),
              activeIcon: Icon(Icons.local_florist, size: 22),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 22),
              activeIcon: Icon(Icons.favorite, size: 22),
              label: '좋아요',
            ),
          ],
        ),
      ),
    );
  }
}
