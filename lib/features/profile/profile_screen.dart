import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_progress_bar.dart';
import '../../features/admin/admin_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 72),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nameRow(),
                const SizedBox(height: 16),
                Text(
                  'Full-stack dev. Building in public, one streak at a time.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    _SocialBtn(Icons.code),
                    SizedBox(width: 12),
                    _SocialBtn(Icons.work_outline),
                    SizedBox(width: 12),
                    _SocialBtn(Icons.alternate_email),
                  ],
                ),
                const SizedBox(height: 24),
                _currentFocus(),
                const SizedBox(height: 24),
                Text('SETTINGS', style: AppTextStyles.label),
                const SizedBox(height: 12),
                const _SettingRow(Icons.person_outline, 'Account'),
                const SizedBox(height: 8),
                const _SettingRow(Icons.notifications_none, 'Notifications'),
                const SizedBox(height: 8),
                const _SettingRow(Icons.lock_outline, 'Privacy'),
                const SizedBox(height: 8),
                _SettingRow(
                  Icons.admin_panel_settings_outlined,
                  'Admin Panel',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // cover + overlapping avatar
  Widget _header() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 192,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1D2A14), Color(0xFF4A7A0A)],
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
                  AppColors.bg.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: -64,
          child: Container(
            width: 128,
            height: 128,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(Icons.person,
                  size: 60, color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _nameRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alex Mercer', style: AppTextStyles.h2),
              const SizedBox(height: 2),
              Text('@alex_dev', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(9999),
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined,
                      size: 14, color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Text('EDIT',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _currentFocus() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CURRENT FOCUS', style: AppTextStyles.label),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.oliveChip,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.olive),
                ),
                child: const Icon(Icons.code,
                    size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Advanced React Patterns', style: AppTextStyles.h3),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('FRONTEND', style: AppTextStyles.caption),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Custom hooks, compound components and performance patterns.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
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
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  const _SocialBtn(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppColors.textPrimary),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _SettingRow(this.icon, this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: AppTextStyles.body)),
              const Icon(Icons.chevron_right,
                  size: 20, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
