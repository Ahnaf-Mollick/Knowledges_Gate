import 'package:flutter/material.dart';
import 'package:knowledges_gate/helpers/AppTheme.dart';
import 'package:knowledges_gate/helpers/SharedResource.dart';
import 'package:get/get.dart';

enum ResultRank { excellent, good, average, tryAgain }

class QuizResult {
  final int correct;
  final int total;
  final Duration timeTaken;

  const QuizResult({
    required this.correct,
    required this.total,
    required this.timeTaken,
  });

  double get percentage => total > 0 ? (correct / total) * 100 : 0;

  ResultRank get rank {
    if (percentage >= 90) return ResultRank.excellent;
    if (percentage >= 70) return ResultRank.good;
    if (percentage >= 50) return ResultRank.average;
    return ResultRank.tryAgain;
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Parse Get parameters ───────────────────────────────────────────────
    final int totalMarks =
        int.tryParse(Get.parameters['totalmarks']?.toString() ?? '0') ?? 0;
    final int marksObtained =
        int.tryParse(Get.parameters['obtained_marks']?.toString() ?? '0') ?? 0;
    final int secondsTaken =
        int.tryParse(Get.parameters['time_taken']?.toString() ?? '0') ?? 0;

    // ── Build result & rank ────────────────────────────────────────────────
    final result = QuizResult(
      correct: marksObtained,
      total: totalMarks,
      timeTaken: Duration(seconds: secondsTaken),
    );

    final rank = result.rank;
    final rankData = _rankData(rank);

    // ── Navigation helpers ─────────────────────────────────────────────────
    void onHome() => Get.offAllNamed('/home');
    void onRetry() => Get.offAllNamed('/question');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── Close / home button ──────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onHome,
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
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // ── Trophy illustration ──────────────────────────────────────
              _TrophyIllustration(rank: rank),

              const SizedBox(height: 28),

              // ── Rank chip ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: rankData.chipColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  rankData.label,
                  style: AppTextStyles.label.copyWith(
                    color: rankData.chipTextColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Headline & subtitle ──────────────────────────────────────
              Text(
                rankData.headline,
                style: AppTextStyles.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                rankData.subtitle,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ── Score card ───────────────────────────────────────────────
              _ScoreCard(result: result),

              const Spacer(),

              // ── CTA buttons ──────────────────────────────────────────────
              PrimaryButton(label: 'Try Again', onTap: onRetry),
              const SizedBox(height: 12),
              OutlineButton(label: 'Back to Home', onTap: onHome),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ── Rank → display data ────────────────────────────────────────────────────
  _RankData _rankData(ResultRank rank) {
    switch (rank) {
      case ResultRank.excellent:
        return const _RankData(
          label: '🏆 Excellent',
          headline: 'Quiz Master!',
          subtitle: 'You nailed it — perfect score territory!',
          chipColor: Color(0xFFFEF9C3),
          chipTextColor: Color(0xFF854D0E),
        );
      case ResultRank.good:
        return const _RankData(
          label: '⭐ Great Job',
          headline: 'Almost There!',
          subtitle: 'You did really well. Keep it up!',
          chipColor: Color(0xFFDCFCE7),
          chipTextColor: Color(0xFF166534),
        );
      case ResultRank.average:
        return const _RankData(
          label: '👍 Average',
          headline: 'Good Effort!',
          subtitle: "A little more practice and you'll ace it.",
          chipColor: Color(0xFFE0F2FE),
          chipTextColor: Color(0xFF075985),
        );
      case ResultRank.tryAgain:
        return const _RankData(
          label: '💪 Keep Going',
          headline: "Don't Give Up!",
          subtitle: 'Practice makes perfect. Give it another shot!',
          chipColor: Color(0xFFFFE4E6),
          chipTextColor: Color(0xFF9F1239),
        );
    }
  }
}

// ── Score Card ────────────────────────────────────────────────────────────────
class _ScoreCard extends StatelessWidget {
  final QuizResult result;
  const _ScoreCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final minutes = result.timeTaken.inMinutes.toString().padLeft(2, '0');
    final seconds = (result.timeTaken.inSeconds % 60).toString().padLeft(
      2,
      '0',
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _StatItem(
            value: '${result.correct}/${result.total}',
            label: 'Correct',
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.successGreen,
          ),
          _Divider(),
          _StatItem(
            value: '${result.percentage.round()}%',
            label: 'Score',
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.primary,
          ),
          _Divider(),
          _StatItem(
            value: '$minutes:$seconds',
            label: 'Time',
            icon: Icons.timer_rounded,
            iconColor: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 48, color: AppColors.divider);
}

// ── Trophy Illustration ───────────────────────────────────────────────────────
class _TrophyIllustration extends StatelessWidget {
  final ResultRank rank;
  const _TrophyIllustration({required this.rank});

  @override
  Widget build(BuildContext context) {
    final emoji = rank == ResultRank.excellent
        ? '🏆'
        : rank == ResultRank.good
        ? '⭐'
        : rank == ResultRank.average
        ? '👍'
        : '💪';

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
        ),
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 52)),
          ),
        ),
      ],
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────
class _RankData {
  final String label;
  final String headline;
  final String subtitle;
  final Color chipColor;
  final Color chipTextColor;

  const _RankData({
    required this.label,
    required this.headline,
    required this.subtitle,
    required this.chipColor,
    required this.chipTextColor,
  });
}
