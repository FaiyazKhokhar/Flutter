import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const _total = 25 * 60;
  int _remaining = _total;
  bool _running = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_running) return;
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
        setState(() {
          _remaining = 0;
          _running = false;
        });
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _remaining = _total;
    });
  }

  String get _label {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        children: [
          _timerCard(),
          const SizedBox(height: 24),
          _currentFocus(),
        ],
      ),
    );
  }

  Widget _timerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
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
      child: Column(
        children: [
          Text(
            'Time to focus!',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(color: const Color(0xFFE0E5CF)),
          ),
          const SizedBox(height: 4),
          Text(
            'Stay in the zone. Block out distractions.',
            textAlign: TextAlign.center,
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.navInactive),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 256,
            height: 256,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(256, 256),
                  painter: _RingPainter(_remaining / _total),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _label,
                      style: GoogleFonts.sora(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.oliveChip,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: AppColors.olive),
                      ),
                      child: Text(
                        'DEEP WORK',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundBtn(Icons.pause, _running ? _pause : null),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: _startBtn(),
              ),
              const SizedBox(width: 12),
              _roundBtn(Icons.refresh, _reset),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback? onTap) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: Material(
        color: AppColors.surfaceAlt,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(icon, size: 22, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }

  Widget _startBtn() {
    return Container(
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
          onTap: _running ? null : _start,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow, size: 18, color: AppColors.bg),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _running ? 'RUNNING' : 'START SESSION',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _currentFocus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF323728),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.olive),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CURRENT FOCUS',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.navInactive)),
                const SizedBox(height: 2),
                Text(
                  'Complete Redux Setup',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 20, color: AppColors.navInactive),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; // 0..1 remaining
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = AppColors.surfaceAlt;
    canvas.drawArc(rect, 0, math.pi * 2, false, track);

    final sweep = math.pi * 2 * progress;

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = const Color.fromRGBO(182, 255, 0, 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, glow);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primary;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, arc);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}