// Screens: JumbledGameOverScreen — time's up screen for Jumbled Words mode
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/ad_helper.dart';
import '../providers/jumbled_game_provider.dart';
import '../providers/progress_provider.dart';
import 'jumbled_game_screen.dart';

class JumbledGameOverScreen extends StatefulWidget {
  final int level;
  final int timeLimit;

  const JumbledGameOverScreen({
    super.key,
    required this.level,
    required this.timeLimit,
  });

  @override
  State<JumbledGameOverScreen> createState() => _JumbledGameOverScreenState();
}

class _JumbledGameOverScreenState extends State<JumbledGameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shake;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
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
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final starsDeducted = widget.timeLimit;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Animated icon
                AnimatedBuilder(
                  animation: _shake,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(_shake.value, 0),
                    child: child,
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF006E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.timer_off_rounded,
                        color: Colors.white, size: 56),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Time's Up!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? const Color(0xFFFF8080)
                        : const Color(0xFFFF3B3B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You ran out of time on Jumbled Level ${widget.level}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? const Color(0xFF8B84FF)
                        : const Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(height: 20),
                // Deducted Stars Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFFF6B6B), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_half_rounded,
                          color: Color(0xFFFF6B6B), size: 26),
                      const SizedBox(width: 8),
                      Text(
                        '-$starsDeducted Stars Deducted',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Total Stars Chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF242540)
                        : const Color(0xFFF0F2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: Color(0xFFFFBE0B), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Total Stars: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF8B84FF)
                              : const Color(0xFF6C63FF),
                        ),
                      ),
                      Text(
                        '${progress.jumbledTotalStars}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? const Color(0xFFE8E9FF)
                              : const Color(0xFF1A1B2E),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Retry button with Rewarded Video Ad
                GestureDetector(
                  onTap: () {
                    AdHelper.showRewardedAd(
                      onRewardGranted: () {
                        context.read<JumbledGameProvider>().reset();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JumbledGameScreen(level: widget.level),
                          ),
                        );
                      },
                      onAdClosed: () {},
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF006E)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.ondemand_video_rounded,
                            color: Colors.white, size: 26),
                        SizedBox(width: 10),
                        Text('Watch Ad to Retry',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () {
                    context.read<JumbledGameProvider>().reset();
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
