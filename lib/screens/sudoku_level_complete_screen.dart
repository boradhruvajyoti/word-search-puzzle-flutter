// Screens: SudokuLevelCompleteScreen — win screen for Sudoku mode
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/ad_helper.dart';
import '../logic/sudoku_level_manager.dart';
import '../providers/progress_provider.dart';
import '../providers/sudoku_game_provider.dart';
import '../widgets/star_rating.dart';
import '../utils/extensions.dart';
import 'sudoku_game_screen.dart';

class SudokuLevelCompleteScreen extends StatefulWidget {
  final int level;
  final int timeRemaining;

  const SudokuLevelCompleteScreen({
    super.key,
    required this.level,
    required this.timeRemaining,
  });

  @override
  State<SudokuLevelCompleteScreen> createState() =>
      _SudokuLevelCompleteScreenState();
}

class _SudokuLevelCompleteScreenState extends State<SudokuLevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = SudokuLevelManager.configForLevel(widget.level);
    final stars = SudokuLevelManager.starsEarned(
        widget.timeRemaining, config.timeLimit);
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextLevel = widget.level + 1;
    final starsRewarded = widget.timeRemaining;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Trophy icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3A86FF), Color(0xFF6C63FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3A86FF).withValues(alpha: 0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.grid_4x4_rounded,
                        color: Colors.white, size: 56),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sudoku Level ${widget.level} Solved!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? const Color(0xFFE8E9FF)
                          : const Color(0xFF1A1B2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    SudokuLevelManager.difficultyName(widget.level),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF8B84FF)
                          : const Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 24),
                  StarRating(stars: stars),
                  const SizedBox(height: 20),
                  // Stars rewarded badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFFBE0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFFFBE0B), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFBE0B), size: 28),
                        const SizedBox(width: 8),
                        Text(
                          '+$starsRewarded Stars Earned!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFBE0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Info chips
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      _InfoChip(
                        label: 'Time Left',
                        value: widget.timeRemaining.toTimerString(),
                        icon: Icons.timer_rounded,
                        isDark: isDark,
                      ),
                      _InfoChip(
                        label: 'Total Stars',
                        value: '${progress.sudokuStars}',
                        icon: Icons.stars_rounded,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Next Level button
                  _GradientButton(
                    label: 'Next Level',
                    icon: Icons.arrow_forward_rounded,
                    onTap: () {
                      void navigate() {
                        context.read<SudokuGameProvider>().reset();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SudokuGameScreen(level: nextLevel),
                          ),
                        );
                      }

                      // Show interstitial every 5 levels (same logic as Word Search)
                      if (widget.level % 5 == 0) {
                        AdHelper.showInterstitialAd(navigate);
                      } else {
                        navigate();
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {
                      context.read<SudokuGameProvider>().reset();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF8B84FF)
                            : const Color(0xFF6C63FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242540) : const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF3A86FF), size: 22),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? const Color(0xFF8B84FF)
                  : const Color(0xFF6C63FF),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? const Color(0xFFE8E9FF)
                  : const Color(0xFF1A1B2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3A86FF), Color(0xFF6C63FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A86FF).withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            const SizedBox(width: 10),
            Icon(icon, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}
