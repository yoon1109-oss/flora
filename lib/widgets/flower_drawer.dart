import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/database_helper.dart';
import 'flovers_logo.dart';
import '../theme/app_theme.dart';

class FlowerDrawer extends StatefulWidget {
  final void Function(String flowerName) onFlowerSelected;

  const FlowerDrawer({super.key, required this.onFlowerSelected});

  @override
  State<FlowerDrawer> createState() => _FlowerDrawerState();
}

class _FlowerDrawerState extends State<FlowerDrawer> {
  final _dbHelper = DatabaseHelper();
  List<String> _allNames = [];
  String _searchQuery = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFlowers();
  }

  Future<void> _loadFlowers() async {
    try {
      final names = await _dbHelper.getAllFlowerNames();
      if (!mounted) return;
      setState(() {
        _allNames = names;
        _loading = false;
      });
    } catch (e) {
      debugPrint('FlowerDrawer _loadFlowers error: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<String> get _filteredNames {
    if (_searchQuery.isEmpty) return _allNames;
    return _allNames.where((n) => n.contains(_searchQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _getGroupedNames(_filteredNames);

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 드로어 타이틀
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: FloversLogo(fontSize: 20),
              ),
              // 검색창
              Container(
                decoration: BoxDecoration(
                  color: AppColors.parchment,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: '꽃 이름 검색',
                    hintStyle: GoogleFonts.lato(
                      color: AppColors.textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search,
                        size: 18, color: AppColors.textLight),
                  ),
                  style: GoogleFonts.notoSerifKr(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 4),

              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.dustyRose))
                    : _error != null
                        ? Center(child: Text('오류: $_error'))
                        : _allNames.isEmpty
                            ? const Center(child: Text('꽃 데이터가 없습니다.'))
                            : ListView.builder(
                                padding: const EdgeInsets.only(top: 8),
                                itemCount: grouped.length,
                                itemBuilder: (context, groupIndex) {
                                  final consonant =
                                      grouped.keys.elementAt(groupIndex);
                                  final names = grouped[consonant]!;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (groupIndex > 0)
                                        const SizedBox(height: 14),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 2),
                                        child: Text(
                                          consonant,
                                          style: GoogleFonts.lato(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.dustyRose,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      ...names.map((name) => InkWell(
                                            onTap: () =>
                                                widget.onFlowerSelected(name),
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: AppColors.border,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                name,
                                                style: GoogleFonts.notoSerifKr(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textDark,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, List<String>> _getGroupedNames(List<String> names) {
  final Map<String, List<String>> grouped = {};

  for (final name in names) {
    final initial = _getKoreanInitial(name);
    grouped.putIfAbsent(initial, () => []).add(name);
  }

  final sortedKeys = grouped.keys.toList()..sort();
  return Map.fromEntries(sortedKeys.map((k) => MapEntry(k, grouped[k]!)));
}

String _getKoreanInitial(String text) {
  if (text.isEmpty) return '';
  final code = text.codeUnitAt(0);
  if (code < 0xAC00 || code > 0xD7A3) return text[0];

  const initials = [
    '\u3131', '\u3132', '\u3134', '\u3137', '\u3138', '\u3139', '\u3141',
    '\u3142', '\u3143', '\u3145', '\u3146', '\u3147', '\u3148', '\u3149',
    '\u314A', '\u314B', '\u314C', '\u314D', '\u314E',
  ];
  final index = ((code - 0xAC00) / 588).floor();
  return initials[index];
}
