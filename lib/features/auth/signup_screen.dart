import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onSignUp() {
    // TODO: navigate to OTP screen later
    debugPrint('Sign up: ${_usernameCtrl.text} / ${_emailCtrl.text}');
  }

  void _onLogin() {
    // TODO: navigate to Login screen later
    debugPrint('Go to login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const _AmbientGlow(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildCard(),
                      const SizedBox(height: 24),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'DevCade',
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          'Join the community',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 4),
        Text(
          'Start your journey to mastery.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildCard() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.35),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(47, 47, 50, 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color.fromRGBO(69, 69, 74, 0.5)),
            ),
            child: Stack(
              children: [
                // top accent line
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: 4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(177, 248, 0, 0),
                            AppColors.primary,
                            Color.fromRGBO(177, 248, 0, 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AuthField(
                        label: 'USERNAME',
                        hint: 'Choose a username',
                        icon: Icons.person_outline,
                        controller: _usernameCtrl,
                      ),
                      const SizedBox(height: 16),
                      _AuthField(
                        label: 'EMAIL',
                        hint: 'Enter your email',
                        icon: Icons.mail_outline,
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _AuthField(
                        label: 'PASSWORD',
                        hint: 'Create a strong password',
                        icon: Icons.lock_outline,
                        controller: _passwordCtrl,
                        obscure: _obscure,
                        suffix: GestureDetector(
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SignUpButton(onTap: _onSignUp),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 24 / 16,
            color: AppColors.textMuted,
          ),
        ),
        GestureDetector(
          onTap: _onLogin,
          child: Text(
            'Log In',
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Soft lime glow blobs behind the content.
class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: -140,
            top: -80,
            child: _blob(width: 300, height: 520, opacity: 0.16),
          ),
          Positioned(
            right: -120,
            bottom: -60,
            child: _blob(width: 260, height: 420, opacity: 0.12),
          ),
        ],
      ),
    );
  }

  Widget _blob({
    required double width,
    required double height,
    required double opacity,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(9999),
        gradient: RadialGradient(
          colors: [
            AppColors.primary.withOpacity(opacity),
            AppColors.primary.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

/// Label + input field (Figma: bg #2F2F32, border #45454A, radius 8).
class _AuthField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const _AuthField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(label, style: AppTextStyles.label),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          cursorColor: AppColors.primary,
          style: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Icon(icon, size: 18, color: AppColors.textMuted),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            suffixIcon: suffix == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: suffix,
                  ),
            suffixIconConstraints: const BoxConstraints(minWidth: 0),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

/// Lime CTA (Figma: #B6FF00, radius 18, glow shadow).
class _SignUpButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SignUpButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryCta,
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SIGN UP', style: AppTextStyles.button),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 14, color: AppColors.bg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}