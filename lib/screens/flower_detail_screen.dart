import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flower.dart';
import '../data/database_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/flower_drawer.dart';
import '../widgets/flovers_logo.dart';
import 'season_flowers_screen.dart';

class FlowerDetailScreen extends StatefulWidget {
  final String initialFlowerName;

  const FlowerDetailScreen({super.key, required this.initialFlowerName});

  @override
  State<FlowerDetailScreen> createState() => _FlowerDetailScreenState();
}

class _FlowerDetailScreenState extends State<FlowerDetailScreen> {
  final _dbHelper = DatabaseHelper();
  final _pageController = PageController();
  Flower? _flower;
  bool _loading = true;
  int _selectedImageIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFlower(widget.initialFlowerName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadFlower(String name) async {
    setState(() => _loading = true);
    try {
      final flower = await _dbHelper.getFlowerByName(name);
      final fav = flower?.id != null ? await _dbHelper.isFavorite(flower!.id!) : false;
      if (!mounted) return;
      setState(() {
        _flower = flower;
        _isFavorite = fav;
        _selectedImageIndex = 0;
        _loading = false;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    } catch (e) {
      debugPrint('FlowerDetailScreen _loadFlower error: $e');
      if (!mounted) return;
      setState(() {
        _flower = null;
        _loading = false;
      });
    }
  }

  void _navigateToFlower(String flowerName) {
    Navigator.of(context).pop();
    _loadFlower(flowerName);
  }

  Future<void> _toggleFavorite() async {
    final id = _flower?.id;
    if (id == null) return;
    await _dbHelper.toggleFavorite(id);
    final fav = await _dbHelper.isFavorite(id);
    if (!mounted) return;
    setState(() => _isFavorite = fav);
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
        actions: const [],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      drawer: FlowerDrawer(onFlowerSelected: _navigateToFlower),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.dustyRose),
            )
          : _flower == null
              ? Center(
                  child: Text(
                    '꽃 데이터를 찾을 수 없습니다.',
                    style: TextStyle(color: AppColors.textLight),
                  ),
                )
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    final flower = _flower!;
    final allImages = flower.thumbnails;
    final currentImage =
        allImages.isNotEmpty && _selectedImageIndex < allImages.length
            ? allImages[_selectedImageIndex].imagePath
            : flower.heroImage;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 히어로 이미지 (스와이프 지원) ──
          AspectRatio(
            aspectRatio: 1,
            child: allImages.length > 1
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: allImages.length,
                    onPageChanged: (i) =>
                        setState(() => _selectedImageIndex = i),
                    itemBuilder: (context, i) => Image.asset(
                      allImages[i].imagePath,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(currentImage, fit: BoxFit.cover),
          ),

          // ── 썸네일 갤러리 ──
          if (allImages.length > 1)
            Container(
              height: 76,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: allImages.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedImageIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedImageIndex = index);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 58,
                      height: 58,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.dustyRose
                              : AppColors.border,
                          width: isSelected ? 2 : 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.asset(
                          allImages[index].imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // ── 꽃 이름 + 하트 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    flower.name,
                    style: GoogleFonts.notoSerifKr(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? AppColors.dustyRose : AppColors.textLight,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // ── 꽃말 (골드 라인 + 텍스트) ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: Row(
              children: [
                Container(width: 22, height: 1, color: AppColors.gold),
                const SizedBox(width: 8),
                Text(
                  flower.floriography,
                  style: GoogleFonts.notoSerifKr(
                    fontSize: 13,
                    color: AppColors.dustyRose,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 22, height: 1, color: AppColors.gold),
              ],
            ),
          ),

          // ── 특징 카드 ──
          _buildCard(
            label: 'Characteristics',
            child: Text(
              flower.feature,
              style: GoogleFonts.notoSerifKr(
                fontSize: 13,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w300,
                height: 1.8,
              ),
            ),
          ),

          const SizedBox(height: 2),

          // ── 플로리스트 리뷰 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 왼쪽 더스티 로즈 바
                  Container(
                    width: 3,
                    decoration: const BoxDecoration(
                      color: AppColors.dustyRose,
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(14)),
                    ),
                  ),
                  // 콘텐츠 영역
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: AppColors.parchment,
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(14)),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -4,
                            left: 0,
                            child: Text(
                              '\u201C',
                              style: AppFonts.playfair(
                                fontSize: 44,
                                fontStyle: FontStyle.italic,
                                color: AppColors.dustyRoseLight,
                                height: 1,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -12,
                            right: 0,
                            child: Text(
                              '\u201D',
                              style: AppFonts.playfair(
                                fontSize: 44,
                                fontStyle: FontStyle.italic,
                                color: AppColors.dustyRoseLight,
                                height: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flower.review,
                                style: GoogleFonts.notoSerifKr(
                                  fontSize: 12,
                                  color: AppColors.textMedium,
                                  fontWeight: FontWeight.w300,
                                  height: 1.9,
                                ),
                              ),
                            ],
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 시즌 태그 구분선 ──
          if (flower.seasons.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              height: 1,
              color: AppColors.border,
            ),

          // ── 시즌 태그 ──
          if (flower.seasons.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: flower.seasons.map((seasonId) {
                  final name = _seasonName(seasonId);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SeasonFlowersScreen(
                            seasonId: seasonId,
                            seasonName: name,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.parchment,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '#$name',
                        style: GoogleFonts.notoSerifKr(
                          fontSize: 12,
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCard({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.parchment,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 14, height: 1, color: AppColors.gold),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 9,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.5,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 1, color: AppColors.border)),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  String _seasonName(int id) {
    switch (id) {
      case 1: return '봄';
      case 2: return '여름';
      case 3: return '가을';
      case 4: return '겨울';
      default: return '';
    }
  }
}
