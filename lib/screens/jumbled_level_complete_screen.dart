// Screens: JumbledLevelCompleteScreen — level complete victory view for Jumbled Words
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/ad_helper.dart';
import '../logic/jumbled_level_manager.dart';
import '../providers/jumbled_game_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/extensions.dart';
import '../widgets/star_rating.dart';
import 'jumbled_game_screen.dart';

class JumbledLevelCompleteScreen extends StatefulWidget {
  final int level;
  final int timeRemaining;

  const JumbledLevelCompleteScreen({
    super.key,
    required this.level,
    required this.timeRemaining,
  });

  @override
  State<JumbledLevelCompleteScreen> createState() =>
      _JumbledLevelCompleteScreenState();
}

class _JumbledLevelCompleteScreenState extends State<JumbledLevelCompleteScreen>
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
    final progress = context.watch<ProgressProvider>();
    final config = JumbledLevelManager.configForLevel(
        widget.level, progress.languageCode);
    final stars =
        JumbledLevelManager.starsEarned(widget.timeRemaining, config.timeLimit);
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
                  // Trophy Icon Container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C9A7), Color(0xFF06D6A0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C9A7).withValues(alpha: 0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.stars_rounded,
                        color: Colors.white, size: 64),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Jumbled Level ${widget.level} Solved!',
                    style: TextStyle(
                      fontSize: 28,
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
                        value: '${progress.jumbledTotalStars}',
                        icon: Icons.stars_rounded,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Action Button with AdMob Interstitial Ad logic
                  GestureDetector(
                    onTap: () {
                      void navigate() {
                        context.read<JumbledGameProvider>().reset();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JumbledGameScreen(level: nextLevel),
                          ),
                        );
                      }

                      if (widget.level % 5 == 0) {
                        AdHelper.showInterstitialAd(navigate);
                      } else {
                        navigate();
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C9A7), Color(0xFF3A86FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C9A7).withValues(alpha: 0.4),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Next Level',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 26),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {
                      context.read<JumbledGameProvider>().reset();
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
          Icon(icon, color: const Color(0xFF00C9A7), size: 22),
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
