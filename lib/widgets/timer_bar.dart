// Widgets: TimerBar — animated countdown progress bar
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';
import '../utils/extensions.dart';

class TimerBar extends StatelessWidget {
  const TimerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final timeLimit = game.config?.timeLimit ?? 1;
    final remaining = game.timeRemaining;
    final ratio = (remaining / timeLimit).clamp(0.0, 1.0);

    final Color barColor;
    if (ratio > 0.5) {
      barColor = AppTheme.timerGood;
    } else if (ratio > 0.25) {
      barColor = AppTheme.timerWarn;
    } else {
      barColor = AppTheme.timerDanger;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Digital countdown
        SizedBox(
          width: 52,
          child: Text(
            remaining.toTimerString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: barColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Progress bar
        Expanded(
          child: Stack(
            children: [
              // Background track
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF242540)
                      : const Color(0xFFE0E3F5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Fill
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 900),
                curve: Curves.linear,
                widthFactor: ratio,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
