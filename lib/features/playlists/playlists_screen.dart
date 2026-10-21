import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_progress_bar.dart';

class _Playlist {
  final String title;
  final String subtitle;
  final double progress;
  final List<Color> colors;
  const _Playlist(this.title, this.subtitle, this.progress, this.colors);
}

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  // mock data. Chip names are my guess, fix from Figma.
  static const _chips = [
    'All', 'React', 'Go', 'CSS', 'Algorithms', 'System Design'
  ];

  static const _all = [
    _Playlist('Deep Dive into Go', '24 videos', 0.30,
        [Color(0xFF1D2A14), Color(0xFF3B5B0F)]),
    _Playlist('CSS Grid Mastery', '12 videos', 0.90,
        [Color(0xFF1B2030), Color(0xFF3A4A7A)]),
  ];

  int _chip = 0;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final list = _all
        .where((p) => p.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(),
          const SizedBox(height: 16),
          _chipRow(),
          const SizedBox(height: 24),
          _sectionTitle('Continue Watching'),
          const SizedBox(height: 16),
          _featuredCard(),
          const SizedBox(height: 24),
          _sectionTitle('All Playlists'),
          const SizedBox(height: 16),
          _grid(list),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: AppTextStyles.h2);

  // ---------- search ----------
  Widget _searchBar() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return SizedBox(
      height: 49,
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        cursorColor: AppColors.primary,
        style: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search your study tracks...',
          hintStyle:
              GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.surface,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon:
              const Icon(Icons.search, size: 20, color: AppColors.textMuted),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  // ---------- chips ----------
  Widget _chipRow() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final on = i == _chip;
          return GestureDetector(
            onTap: () => setState(() => _chip = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? AppColors.primary : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                _chips[i],
                style: AppTextStyles.bodySmall.copyWith(
                  color: on ? AppColors.bg : AppColors.textPrimary,
                  fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- featured ----------
  Widget _featuredCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.35),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image area (placeholder gradient, swap with Figma image later)
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1D2A14), Color(0xFF4A7A0A)],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.surface.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 57,
                  height: 57,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(182, 255, 0, 0.4),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow,
                      size: 30, color: AppColors.bg),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Advanced React Patterns', style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(
                  'Master custom hooks, compound components and performance patterns.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: AppProgressBar(value: 0.65)),
                    const SizedBox(width: 12),
                    Text('65%',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- grid ----------
  Widget _grid(List<_Playlist> items) {
    return LayoutBuilder(builder: (context, c) {
      const gap = 16.0;
      final w = (c.maxWidth - gap) / 2;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final p in items) SizedBox(width: w, child: _gridCard(p)),
          if (_query.isEmpty) SizedBox(width: w, child: _newCard()),
        ],
      );
    });
  }

  Widget _gridCard(_Playlist p) {
    final pct = (p.progress * 100).round();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: p.colors,
              ),
            ),
            child: const Icon(Icons.play_circle_outline,
                size: 32, color: AppColors.textPrimary),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3.copyWith(fontSize: 14, height: 1.3),
                ),
                const SizedBox(height: 4),
                Text(p.subtitle, style: AppTextStyles.caption),
                const SizedBox(height: 12),
                AppProgressBar(value: p.progress, height: 6),
                const SizedBox(height: 6),
                Text('$pct%',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _newCard() {
    return Container(
      height: 215,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.olive),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.surface,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 26, color: AppColors.bg),
          ),
          const SizedBox(height: 12),
          Text('NEW PLAYLIST', style: AppTextStyles.label),
        ],
      ),
    );
  }
}