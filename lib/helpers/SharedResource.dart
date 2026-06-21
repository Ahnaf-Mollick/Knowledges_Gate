import 'package:flutter/material.dart';
import 'AppTheme.dart';

/// Primary pill button (yellow accent)
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.textDark,
                ),
              )
            : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

/// Ghost/outline button
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const OutlineButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.optionBorder, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

/// Back arrow button (circle)
class CircleBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const CircleBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.maybePop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

/// Timer badge (top-right of question screen)
class TimerBadge extends StatelessWidget {
  final String timeLabel;
  const TimerBadge({super.key, required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 8),
        ],
      ),
      child: Text(
        timeLabel,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}

/// Custom text input field
class AppTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? suffix;

  const AppTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textGrey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}

/// Question number + progress bar row
class QuestionProgress extends StatelessWidget {
  final int current;
  final int total;

  const QuestionProgress({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Q. $current', style: AppTextStyles.label.copyWith(fontSize: 16)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: AppColors.divider,
            color: AppColors.primary,
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
