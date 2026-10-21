import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class _Dev {
  final int rank;
  final String name;
  final int xp;
  final bool me;
  const _Dev(this.rank, this.name, this.xp, {this.me = false});
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  // mock data (names and XP are my guess, fix from Figma)
  static const _top = [
    _Dev(1, 'Sara Khan', 12450),
    _Dev(2, 'Liam Chen', 11980),
    _Dev(3, 'Priya Nair', 11200),
  ];
  static const _rest = [
    _Dev(4, 'Alex Mercer', 10150, me: true),
    _Dev(5, 'Omar Diaz', 9870),
  ];

  // medal colors are my guess
  static const _gold = Color(0xFFFFD34D);
  static const _silver = Color(0xFFC9CED6);
  static const _bronze = Color(0xFFD99058);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  children: [
                    _badge(),
                    const SizedBox(height: 16),
                    Text('Gold League', style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text('Top 3 get promoted on Sunday',
                        style: AppTextStyles.bodySmall),
                    const SizedBox(height: 24),
                    _tableHeader(),
                    const SizedBox(height: 12),
                    for (final d in _top) ...[
                      _row(d),
                      const SizedBox(height: 12),
                    ],
                    _promotionDivider(),
                    const SizedBox(height: 12),
                    for (final d in _rest) ...[
                      _row(d),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                    _cta(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.olive)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back,
                size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          Text(
            'Leaderboard',
            style: GoogleFonts.sora(
              fontSize: 16,
              letterSpacing: -0.6,
              color: AppColors.logoLime,
            ),
          ),
        ],
      ),
    );
  }

  // 80x80 trophy badge
  Widget _badge() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.oliveChip,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.olive),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(182, 255, 0, 0.25),
            blurRadius: 24,
          ),
        ],
      ),
      child: const Icon(Icons.emoji_events, size: 40, color: AppColors.primary),
    );
  }

  Widget _tableHeader() {
    final s = AppTextStyles.caption;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(width: 48, child: Text('RANK', style: s)),
          Expanded(child: Text('DEVELOPER', style: s)),
          Text('XP', style: s),
        ],
      ),
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return _gold;
      case 2:
        return _silver;
      case 3:
        return _bronze;
      default:
        return AppColors.textMuted;
    }
  }

  Widget _row(_Dev d) {
    final first = d.rank == 1;
    final rc = _rankColor(d.rank);
    return Container(
      height: first ? 75 : 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: d.me ? const Color(0xFF232A12) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: d.me ? AppColors.primary : AppColors.border,
        ),
        boxShadow: d.me
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(182, 255, 0, 0.25),
                  blurRadius: 16,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              '${d.rank}',
              style: GoogleFonts.sora(
                fontSize: first ? 24 : 18,
                fontWeight: FontWeight.w700,
                color: rc,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
              border: Border.all(
                color: d.rank <= 3 ? rc : AppColors.border,
                width: 2,
              ),
            ),
            child: Text(
              d.name[0],
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    d.me ? '${d.name} (You)' : d.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: d.me ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (first) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.local_fire_department,
                      size: 16, color: AppColors.primary),
                ],
              ],
            ),
          ),
          Text(
            _fmt(d.xp),
            style: AppTextStyles.label.copyWith(
              color: d.me ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }

  Widget _promotionDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.olive, height: 1)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.oliveChip,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.olive),
          ),
          child: Row(
            children: [
              const Icon(Icons.arrow_upward,
                  size: 12, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('PROMOTION ZONE',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.primary, fontSize: 10)),
            ],
          ),
        ),
        const Expanded(child: Divider(color: AppColors.olive, height: 1)),
      ],
    );
  }

  Widget _cta(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(182, 255, 0, 0.25),
            offset: Offset(0, 12),
            blurRadius: 16,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow, size: 18, color: AppColors.bg),
                const SizedBox(width: 8),
                Text('EARN MORE XP', style: AppTextStyles.button),
              ],
            ),
          ),
        ),
      ),
    );
  }
}