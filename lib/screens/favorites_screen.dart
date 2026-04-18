import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flower.dart';
import '../data/database_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/flovers_logo.dart';
import '../widgets/flower_drawer.dart';
import 'flower_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _dbHelper = DatabaseHelper();
  List<Flower> _flowers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final flowers = await _dbHelper.getFavoriteFlowers();
    if (!mounted) return;
    setState(() {
      _flowers = flowers;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 22),
            color: AppColors.textMedium,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const FloversLogo(fontSize: 22),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      drawer: FlowerDrawer(
        onFlowerSelected: (name) {
          Navigator.of(context).pop(); // 드로어 닫기
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FlowerDetailScreen(initialFlowerName: name),
            ),
          );
        },
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.dustyRose),
            )
          : _flowers.isEmpty
              ? _buildEmpty()
              : _buildGrid(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border,
            size: 48,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            '좋아요한 꽃이 없습니다',
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppColors.textLight,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _flowers.length,
      itemBuilder: (context, index) {
        final flower = _flowers[index];
        return _FavoriteCard(
          flower: flower,
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FlowerDetailScreen(
                  initialFlowerName: flower.name,
                ),
              ),
            );
            _loadFavorites();
          },
          onUnfavorite: () async {
            await _dbHelper.toggleFavorite(flower.id!);
            _loadFavorites();
          },
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Flower flower;
  final VoidCallback onTap;
  final VoidCallback onUnfavorite;

  const _FavoriteCard({
    required this.flower,
    required this.onTap,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.parchment,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(13)),
                    child: Image.asset(
                      flower.heroImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onUnfavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 18,
                          color: AppColors.dustyRose,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flower.name,
                    style: GoogleFonts.notoSerifKr(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    flower.floriography,
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: AppColors.dustyRose,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
