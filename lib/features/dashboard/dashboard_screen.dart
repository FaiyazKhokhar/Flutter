import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_progress_bar.dart';
import '../leaderboard/leaderboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onStartFocus;
  const DashboardScreen({super.key, this.onStartFocus});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // mock data
  static const _weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  static const _weekHours = [2.5, 4.0, 5.5, 3.0, 4.5, 1.5, 2.0];
  static const _highlight = 2; // Wed

  // 0 = empty, 1..3 = intensity. 2 rows x 15 columns = 30 days.
  static const _heat = [
    0, 1, 2, 3, 1, 0, 2, 3, 3, 2, 1, 0, 2, 3, 3,
    1, 0, 1, 2, 2, 3, 1, 0, 1, 3, 2, 2, 3, 1, 3,
  ];

  final _tasks = [
    ['Complete Redux Setup', 'High'],
    ['Read Docs on Context API', ''],
  ];
  final _done = [false, false];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _greeting(),
          const SizedBox(height: 24),
          _streakCard(),
          const SizedBox(height: 24),
          _weeklyLoad(),
          const SizedBox(height: 24),
          _studyActivity(),
          const SizedBox(height: 24),
          _continuePlaylist(),
          const SizedBox(height: 24),
          _activeTasks(),
        ],
      ),
    );
  }

  // ---------- greeting ----------
  Widget _greeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, Alex',
          style: AppTextStyles.display.copyWith(letterSpacing: -0.8),
        ),
        const SizedBox(height: 8),
        Text('Ready to level up today?', style: AppTextStyles.body),
        const SizedBox(height: 24),
        Container(
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
              onTap: widget.onStartFocus,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow,
                        size: 18, color: AppColors.bg),
                    const SizedBox(width: 8),
                    Text('START FOCUS SESSION', style: AppTextStyles.button),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- streak ----------
  Widget _streakCard() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
      ),
      child: _streakCardBody(),
    );
  }
  Widget _streakCardBody() {
    return Container(
      width: double.infinity,
      height: 208,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(182, 255, 0, 0.25),
            offset: Offset(0, 12),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CURRENT STREAK',
                style: AppTextStyles.label
                    .copyWith(color: AppColors.onPrimaryMuted),
              ),
              const Icon(Icons.local_fire_department,
                  size: 28, color: AppColors.bg),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '14',
                style: GoogleFonts.sora(
                  fontSize: 64,
                  height: 1,
                  letterSpacing: -1.6,
                  color: AppColors.bg,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Days of continuous coding',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.onPrimaryMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- weekly load ----------
  Widget _weeklyLoad() {
    const maxH = 6.0;
    const chartH = 140.0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Load', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          SizedBox(
            height: chartH + 28,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final on = i == _highlight;
                final barH = (_weekHours[i] / maxH) * (chartH - 30);
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (on)
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_weekHours[i]}h',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.bg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      Container(
                        width: 28,
                        height: barH,
                        decoration: BoxDecoration(
                          color: on ? AppColors.primary : AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: on
                              ? const [
                                  BoxShadow(
                                    color: Color.fromRGBO(182, 255, 0, 0.4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _weekDays[i],
                        style: AppTextStyles.caption.copyWith(
                          color: on
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- heatmap ----------
  Widget _studyActivity() {
    Color cell(int level) {
      switch (level) {
        case 1:
          return const Color.fromRGBO(155, 217, 0, 0.4);
        case 2:
          return const Color.fromRGBO(155, 217, 0, 0.8);
        case 3:
          return AppColors.primary;
        default:
          return AppColors.surfaceAlt;
      }
    }

    const cols = 15;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Study Activity', style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text('Last 30 days', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(cols, (c) {
                return Padding(
                  padding: EdgeInsets.only(right: c == cols - 1 ? 0 : 4),
                  child: Column(
                    children: List.generate(2, (r) {
                      final level = _heat[r * cols + c];
                      return Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.only(bottom: r == 0 ? 4 : 0),
                        decoration: BoxDecoration(
                          color: cell(level),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: level == 3
                              ? const [
                                  BoxShadow(
                                    color: Color.fromRGBO(182, 255, 0, 0.4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- continue playlist ----------
  Widget _continuePlaylist() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONTINUE PLAYLIST', style: AppTextStyles.label),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_arrow,
                    size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Advanced React Patterns', style: AppTextStyles.h3),
                    const SizedBox(height: 4),
                    Text('Module 4: Custom Hooks',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
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
    );
  }

  // ---------- active tasks ----------
  Widget _activeTasks() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Active Tasks', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          for (int i = 0; i < _tasks.length; i++) ...[
            _taskItem(i),
            if (i != _tasks.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _taskItem(int i) {
    final title = _tasks[i][0];
    final tag = _tasks[i][1];
    final done = _done[i];
    return GestureDetector(
      onTap: () => setState(() => _done[i] = !done),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: done ? AppColors.primary : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 14, color: AppColors.bg)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: done ? AppColors.textMuted : AppColors.textPrimary,
                  decoration: done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (tag.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(251, 187, 90, 0.10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: AppTextStyles.caption
                      .copyWith(color: const Color(0xFFFBBB5A)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}