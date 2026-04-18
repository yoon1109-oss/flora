import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/database_helper.dart';
import '../models/flower.dart';
import '../theme/app_theme.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _db = DatabaseHelper();
  List<Flower> _flowers = [];
  List<Flower> _filtered = [];
  bool _loading = true;
  String _filter = 'all'; // all, has, none
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final flowers = await _db.getAllFlowers();
    flowers.sort((a, b) => a.name.compareTo(b.name));
    if (!mounted) return;
    setState(() {
      _flowers = flowers;
      _loading = false;
    });
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      _filtered = _flowers.where((f) {
        final matchSearch = _search.isEmpty ||
            f.name.contains(_search);
        final matchFilter = _filter == 'all'
            ? true
            : _filter == 'has'
                ? f.images.isNotEmpty
                : f.images.isEmpty;
        return matchSearch && matchFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasCount = _flowers.where((f) => f.images.isNotEmpty).length;
    final noneCount = _flowers.where((f) => f.images.isEmpty).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Admin — 사진 목록',
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
            letterSpacing: 1,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            color: AppColors.textMedium,
            onPressed: _load,
            tooltip: '새로고침',
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.dustyRose))
          : Column(
              children: [
                // 통계 바
                Container(
                  color: AppColors.parchment,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      _statChip('전체', _flowers.length, 'all',
                          AppColors.textMedium),
                      const SizedBox(width: 8),
                      _statChip('사진있음', hasCount, 'has',
                          AppColors.sage),
                      const SizedBox(width: 8),
                      _statChip('사진없음', noneCount, 'none',
                          AppColors.dustyRose),
                    ],
                  ),
                ),
                Container(color: AppColors.border, height: 1),
                // 검색
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: TextField(
                    onChanged: (v) {
                      _search = v;
                      _applyFilter();
                    },
                    style: GoogleFonts.notoSerifKr(
                        fontSize: 13, color: AppColors.textDark),
                    decoration: InputDecoration(
                      hintText: '꽃 이름 검색...',
                      hintStyle: GoogleFonts.notoSerifKr(
                          fontSize: 13, color: AppColors.textLight),
                      prefixIcon: const Icon(Icons.search,
                          size: 18, color: AppColors.textLight),
                      filled: true,
                      fillColor: AppColors.parchment,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.dustyRose, width: 1.5),
                      ),
                    ),
                  ),
                ),
                // 결과 수
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
                  child: Row(
                    children: [
                      Text(
                        '${_filtered.length}개 결과',
                        style: GoogleFonts.lato(
                          fontSize: 11,
                          color: AppColors.textLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // 목록
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final flower = _filtered[i];
                      return _FlowerAdminTile(flower: flower);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statChip(String label, int count, String filterKey, Color color) {
    final selected = _filter == filterKey;
    return GestureDetector(
      onTap: () {
        _filter = filterKey;
        _applyFilter();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: selected ? color : AppColors.textLight,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? color.withOpacity(0.2)
                    : AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.lato(
                  fontSize: 11,
                  color: selected ? color : AppColors.textLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowerAdminTile extends StatelessWidget {
  final Flower flower;
  const _FlowerAdminTile({required this.flower});

  @override
  Widget build(BuildContext context) {
    final hasImages = flower.images.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding:
            const EdgeInsets.fromLTRB(14, 0, 14, 12),
        shape: const Border(),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: hasImages
                ? AppColors.sage.withOpacity(0.15)
                : AppColors.dustyRose.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              hasImages ? 'Y' : 'N',
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: hasImages
                    ? AppColors.sage
                    : AppColors.dustyRose,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                flower.name,
                style: GoogleFonts.notoSerifKr(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: hasImages
                    ? AppColors.sage.withOpacity(0.12)
                    : AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                hasImages
                    ? '${flower.images.length}장'
                    : '없음',
                style: GoogleFonts.lato(
                  fontSize: 11,
                  color: hasImages
                      ? AppColors.sage
                      : AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        children: [
          if (!hasImages)
            Text(
              '등록된 사진이 없습니다.',
              style: GoogleFonts.notoSerifKr(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: flower.images
                  .map((img) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.only(
                                  right: 8),
                              decoration: BoxDecoration(
                                color: AppColors.dustyRoseLight
                                    .withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '${img.imageNumber}',
                                  style: GoogleFonts.lato(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.dustyRose,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                img.imagePath.split('/').last,
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: AppColors.textMedium,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
