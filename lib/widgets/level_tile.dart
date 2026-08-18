// Widgets: LevelTile — a single level card with locked/unlocked/star-unlock/retry-ad state
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/constants.dart';

class LevelTile extends StatelessWidget {
  final int level;
  final bool isSudoku;
  final bool isCryptogram;
  final bool isQuadsum;

  /// Called when an unlocked level is tapped.
  final VoidCallback? onTap;

  /// Called when a locked level is tapped — show unlock dialog.
  final VoidCallback? onLockedTap;

  const LevelTile({
    super.key,
    required this.level,
    this.isSudoku = false,
    this.isCryptogram = false,
    this.isQuadsum = false,
    this.onTap,
    this.onLockedTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final isUnlocked = isQuadsum
        ? progress.isQuadsumLevelUnlocked(level)
        : (isCryptogram
            ? progress.isCryptogramLevelUnlocked(level)
            : (isSudoku
                ? progress.isSudokuLevelUnlocked(level)
                : progress.isLevelUnlocked(level)));
    final isRetryAd = isQuadsum
        ? progress.isQuadsumRetryAdRequired(level)
        : (isCryptogram
            ? progress.isCryptogramRetryAdRequired(level)
            : (isSudoku
                ? progress.isSudokuRetryAdRequired(level)
                : progress.isRetryAdRequired(level)));
    final bestTime = isQuadsum
        ? progress.quadsumBestTimeForLevel(level)
        : (isCryptogram
            ? progress.cryptogramBestTimeForLevel(level)
            : (isSudoku
                ? progress.sudokuBestTimeForLevel(level)
                : progress.bestTimeForLevel(level)));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cost = ProgressProvider.starCostToUnlock(level);
    final canAfford = progress.canAffordUnlock(level);

    final Color primary =
        AppConstants.wordColors[(level - 1) % AppConstants.wordColors.length];

    return GestureDetector(
      onTap: isUnlocked ? onTap : onLockedTap,
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
          border: !isUnlocked
              ? Border.all(
                  color: canAfford
                      ? const Color(0xFFFFBE0B).withValues(alpha: 0.6)
                      : Colors.transparent,
                  width: 1.5,
                )
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isUnlocked) ...[
                    // Subtle level number behind lock
                    Text(
                      '$level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white30 : Colors.black26,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Star cost badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            color: canAfford
                                ? const Color(0xFFFFBE0B)
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.2)),
                            size: 11),
                        const SizedBox(width: 2),
                        Text(
                          '$cost',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: canAfford
                                ? const Color(0xFFFFBE0B)
                                : (isDark ? Colors.white30 : Colors.black38),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      '$level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (bestTime != null)
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
                ],
              ),
            ),
            // Retry Ad Required Badge indicator on top-right
            if (isUnlocked && isRetryAd)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF006E),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF006E).withValues(alpha: 0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.ondemand_video_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
