// Widgets: LevelTile — a single level card with locked/unlocked state
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/constants.dart';

class LevelTile extends StatelessWidget {
  final int level;
  final VoidCallback? onTap;

  const LevelTile({super.key, required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final isUnlocked = progress.isLevelUnlocked(level);
    final bestTime = progress.bestTimeForLevel(level);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color primary = AppConstants.wordColors[(level - 1) % AppConstants.wordColors.length];

    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isUnlocked
              ? LinearGradient(
                  colors: [primary, primary.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUnlocked
              ? null
              : (isDark ? const Color(0xFF242540) : const Color(0xFFE8EAFF)),
          borderRadius: BorderRadius.circular(18),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isUnlocked)
                    Icon(Icons.lock_rounded,
                        color: isDark
                            ? Colors.white30
                            : Colors.black26,
                        size: 22)
                  else
                    Text(
                      '$level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  if (isUnlocked && bestTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFBE0B), size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '${bestTime}s',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
