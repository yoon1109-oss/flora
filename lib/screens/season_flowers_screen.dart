import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flower.dart';
import '../data/database_helper.dart';
import '../theme/app_theme.dart';
import 'flower_detail_screen.dart';
import '../widgets/flovers_logo.dart';

class SeasonFlowersScreen extends StatefulWidget {
  final int seasonId;
  final String seasonName;

  const SeasonFlowersScreen({
    super.key,
    required this.seasonId,
    required this.seasonName,
  });

  @override
  State<SeasonFlowersScreen> createState() => _SeasonFlowersScreenState();
}

class _SeasonFlowersScreenState extends State<SeasonFlowersScreen> {
  final _dbHelper = DatabaseHelper();
  List<Flower> _flowers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFlowers();
  }

  Future<void> _loadFlowers() async {
    final flowers = await _dbHelper.getFlowersBySeason(widget.seasonId);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          color: AppColors.textMedium,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const FloversLogo(fontSize: 22),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.dustyRose),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 시즌 헤더 ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _seasonEmoji(widget.seasonId),
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.seasonName} 꽃',
                        style: AppFonts.playfair(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_flowers.length}종',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Text(
                    _seasonEnName(widget.seasonId),
                    style: AppFonts.playfair(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 1,
                  color: AppColors.border,
                ),
                // ── 꽃 그리드 ──
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _flowers.length,
                    itemBuilder: (context, index) {
                      final flower = _flowers[index];
                      return _FlowerCard(
                        flower: flower,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FlowerDetailScreen(
                                initialFlowerName: flower.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  String _seasonEmoji(int id) {
    switch (id) {
      case 1: return '🌸';
      case 2: return '☀️';
      case 3: return '🍂';
      case 4: return '❄️';
      default: return '';
    }
  }

  String _seasonEnName(int id) {
    switch (id) {
      case 1: return 'Spring Flowers';
      case 2: return 'Summer Flowers';
      case 3: return 'Autumn Flowers';
      case 4: return 'Winter Flowers';
      default: return '';
    }
  }
}

class _FlowerCard extends StatelessWidget {
  final Flower flower;
  final VoidCallback onTap;

  const _FlowerCard({required this.flower, required this.onTap});

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
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(13)),
                child: Image.asset(
                  flower.heroImage,
                  fit: BoxFit.cover,
                ),
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
