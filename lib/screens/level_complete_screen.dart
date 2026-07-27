// Screens: LevelCompleteScreen — shows stars rewarded, total stars, time, next level
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/level_manager.dart';
import '../providers/game_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/star_rating.dart';
import '../utils/extensions.dart';
import 'game_screen.dart';

class LevelCompleteScreen extends StatefulWidget {
  final int level;
  final int timeRemaining;

  const LevelCompleteScreen({
    super.key,
    required this.level,
    required this.timeRemaining,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeSlideFade;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeSlideFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim =
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
    final config = LevelManager.configForLevel(widget.level);
    final stars = LevelManager.starsEarned(widget.timeRemaining, config.timeLimit);
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextLevel = widget.level + 1;
    final starsRewarded = widget.timeRemaining;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeSlideFade,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Trophy
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFBE0B), Color(0xFFFF9E00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFBE0B).withValues(alpha: 0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.emoji_events_rounded,
                        color: Colors.white, size: 64),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Level ${widget.level} Complete!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? const Color(0xFFE8E9FF)
                          : const Color(0xFF1A1B2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  StarRating(stars: stars),
                  const SizedBox(height: 20),
                  // Rewarded Stars Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBE0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFFFFBE0B), width: 1.5),
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
                  // Info Chips
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
                        value: '${progress.totalStars}',
                        icon: Icons.stars_rounded,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Next level button
                  _GradientButton(
                    label: 'Next Level',
                    icon: Icons.arrow_forward_rounded,
                    onTap: () {
                      context.read<GameProvider>().reset();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => GameScreen(level: nextLevel)),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {
                      context.read<GameProvider>().reset();
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
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
          Icon(icon, color: const Color(0xFF6C63FF), size: 22),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color:
                  isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
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
            colors: [Color(0xFF6C63FF), Color(0xFF00C9A7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
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
