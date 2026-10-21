import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_progress_bar.dart';

class _Task {
  String title;
  List<String> tags;
  String date;
  bool done;
  _Task(this.title, this.tags, this.date, {this.done = false});
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // mock data. Tags and dates are my guess, fix from Figma.
  final List<_Task> _today = [
    _Task('Solve 5 Leetcode Problems', ['High', 'DSA'], 'Today, 6:00 PM'),
    _Task('Review PR #104', ['Work'], 'Today, 8:30 PM'),
  ];

  static const _upcoming = [
    ['Read System Design Chapter 4', 'Tomorrow'],
    ['Update Portfolio CSS', 'Friday'],
  ];

  int _filter = 0; // 0 = All, 1 = High

  List<_Task> get _visible => _filter == 0
      ? _today
      : _today.where((t) => t.tags.contains('High')).toList();

  Future<void> _addTask() async {
    final ctrl = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('New task', style: AppTextStyles.h3),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          cursorColor: AppColors.primary,
          style: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'What needs doing?',
            hintStyle:
                GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text('ADD',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (title != null && title.trim().isNotEmpty) {
      setState(() => _today.add(_Task(title.trim(), [], 'Today')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _focusCard(),
          const SizedBox(height: 24),
          _tasksHeader(),
          const SizedBox(height: 16),
          for (int i = 0; i < items.length; i++)
            _timelineItem(items[i], isLast: i == items.length - 1),
          const SizedBox(height: 24),
          Text('Upcoming', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          for (final u in _upcoming) ...[
            _upcomingRow(u[0], u[1]),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          _addRow(),
        ],
      ),
    );
  }

  // ---------- today's focus ----------
  Widget _focusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF323728),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.olive),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.35),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text("TODAY'S FOCUS",
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.navInactive)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ship the auth module',
            style: AppTextStyles.h2.copyWith(color: const Color(0xFFE0E5CF)),
          ),
          const SizedBox(height: 4),
          Text('3 of 5 steps done',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.navInactive)),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: AppProgressBar(value: 0.65)),
              const SizedBox(width: 12),
              Text('65%',
                  style:
                      AppTextStyles.label.copyWith(color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- header + filters ----------
  Widget _tasksHeader() {
    Widget chip(String label, int i) {
      final on = _filter == i;
      return GestureDetector(
        onTap: () => setState(() => _filter = i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: on ? AppColors.primary : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: on ? AppColors.bg : AppColors.textPrimary,
              fontWeight: on ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: Text('Tasks', style: AppTextStyles.h2)),
        chip('All', 0),
        const SizedBox(width: 8),
        chip('High', 1),
      ],
    );
  }

  // ---------- timeline ----------
  Widget _timelineItem(_Task t, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => t.done = !t.done),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: t.done ? AppColors.primary : AppColors.bg,
                      border: Border.all(
                        color: t.done ? AppColors.primary : AppColors.textMuted,
                        width: 2,
                      ),
                    ),
                    child: t.done
                        ? const Icon(Icons.check, size: 14, color: AppColors.bg)
                        : null,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: AppColors.olive),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: _taskCard(t),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(_Task t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.title,
            style: AppTextStyles.body.copyWith(
              color: t.done ? AppColors.textMuted : AppColors.textPrimary,
              decoration: t.done ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final tag in t.tags) ...[
                _tag(tag),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  t.date,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String tag) {
    final high = tag == 'High';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: high
            ? const Color.fromRGBO(251, 187, 90, 0.10)
            : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: high ? const Color(0xFFFBBB5A) : AppColors.textSecondary,
        ),
      ),
    );
  }

  // ---------- upcoming ----------
  Widget _upcomingRow(String title, String when) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.radio_button_unchecked,
              size: 20, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTextStyles.bodySmall)),
          const SizedBox(width: 8),
          Text(when, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  // ---------- add ----------
  Widget _addRow() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _addTask,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.olive),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('ADD TASK',
                  style:
                      AppTextStyles.label.copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}