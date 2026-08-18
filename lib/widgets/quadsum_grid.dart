// Widgets: QuadsumGrid — 3x3 grid with 4 floating intersection clue circles
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quadsum_game_provider.dart';

class QuadsumGrid extends StatelessWidget {
  final double size;

  const QuadsumGrid({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<QuadsumGameProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (game.config == null) {
      return SizedBox(
        width: size,
        height: size,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final cellSize = (size - 16) / 3;
    final circleSize = (cellSize * 0.72).clamp(38.0, 56.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 3x3 Board Grid
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF141526) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (r) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (c) {
                    final value = game.grid[r][c];
                    final isSelected = game.selectedRow == r && game.selectedCol == c;
                    final isLocked = game.isCellLocked(r, c);

                    return _QuadsumCell(
                      size: cellSize,
                      value: value,
                      isSelected: isSelected,
                      isLocked: isLocked,
                      isDark: isDark,
                      onTap: () => game.selectCell(r, c),
                    );
                  }),
                );
              }),
            ),
          ),

          // 4 Floating Clue Circles at Quadrant Intersections
          // Top-Left (between row 0-1, col 0-1)
          Positioned(
            left: 4 + cellSize - (circleSize / 2) + 2,
            top: 4 + cellSize - (circleSize / 2) + 2,
            child: _ClueCircle(
              size: circleSize,
              targetSum: game.config!.sumTopLeft,
              currentSum: game.currentSumTopLeft,
              status: game.statusTopLeft,
              isDark: isDark,
            ),
          ),
          // Top-Right (between row 0-1, col 1-2)
          Positioned(
            left: 4 + (cellSize * 2) - (circleSize / 2) + 2,
            top: 4 + cellSize - (circleSize / 2) + 2,
            child: _ClueCircle(
              size: circleSize,
              targetSum: game.config!.sumTopRight,
              currentSum: game.currentSumTopRight,
              status: game.statusTopRight,
              isDark: isDark,
            ),
          ),
          // Bottom-Left (between row 1-2, col 0-1)
          Positioned(
            left: 4 + cellSize - (circleSize / 2) + 2,
            top: 4 + (cellSize * 2) - (circleSize / 2) + 2,
            child: _ClueCircle(
              size: circleSize,
              targetSum: game.config!.sumBottomLeft,
              currentSum: game.currentSumBottomLeft,
              status: game.statusBottomLeft,
              isDark: isDark,
            ),
          ),
          // Bottom-Right (between row 1-2, col 1-2)
          Positioned(
            left: 4 + (cellSize * 2) - (circleSize / 2) + 2,
            top: 4 + (cellSize * 2) - (circleSize / 2) + 2,
            child: _ClueCircle(
              size: circleSize,
              targetSum: game.config!.sumBottomRight,
              currentSum: game.currentSumBottomRight,
              status: game.statusBottomRight,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuadsumCell extends StatelessWidget {
  final double size;
  final int value;
  final bool isSelected;
  final bool isLocked;
  final bool isDark;
  final VoidCallback onTap;

  const _QuadsumCell({
    required this.size,
    required this.value,
    required this.isSelected,
    required this.isLocked,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeBorderColor = Color(0xFF00B4D8);
    final textStyle = TextStyle(
      fontSize: size * 0.42,
      fontWeight: FontWeight.w900,
      color: isLocked
          ? (isDark ? const Color(0xFF00B4D8) : const Color(0xFF0077B6))
          : (isDark ? Colors.white : const Color(0xFF1A1B2E)),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected
              ? activeBorderColor.withValues(alpha: isDark ? 0.35 : 0.22)
              : (isDark
                  ? (isLocked ? const Color(0xFF1E2139) : const Color(0xFF262847))
                  : (isLocked ? const Color(0xFFF1F5F9) : Colors.white)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? activeBorderColor
                : (isDark ? const Color(0xFF383B63) : const Color(0xFFCBD5E1)),
            width: isSelected ? 3.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeBorderColor.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isLocked)
              Positioned(
                top: 4,
                left: 6,
                child: Icon(
                  Icons.lock_rounded,
                  size: 11,
                  color: isDark ? const Color(0xFF00B4D8) : const Color(0xFF0077B6),
                ),
              ),
            Text(
              value > 0 ? '$value' : '',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClueCircle extends StatelessWidget {
  final double size;
  final int targetSum;
  final int currentSum;
  final QuadrantStatus status;
  final bool isDark;

  const _ClueCircle({
    required this.size,
    required this.targetSum,
    required this.currentSum,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color borderColor, Color textColor) = switch (status) {
      QuadrantStatus.correct => (
        const Color(0xFF06D6A0),
        const Color(0xFF00B48A),
        Colors.white,
      ),
      QuadrantStatus.incorrect => (
        const Color(0xFFFF6B6B),
        const Color(0xFFE63946),
        Colors.white,
      ),
      QuadrantStatus.incomplete => (
        isDark ? const Color(0xFF0F172A) : Colors.white,
        const Color(0xFF00B4D8),
        isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
      ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: (status == QuadrantStatus.correct
                    ? const Color(0xFF06D6A0)
                    : (status == QuadrantStatus.incorrect
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFF00B4D8)))
                .withValues(alpha: 0.45),
            blurRadius: status == QuadrantStatus.correct ? 12 : 6,
            spreadRadius: status == QuadrantStatus.correct ? 2 : 0,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$targetSum',
              style: TextStyle(
                fontSize: size * 0.36,
                fontWeight: FontWeight.w900,
                color: textColor,
                height: 1.0,
              ),
            ),
            if (status == QuadrantStatus.correct)
              Icon(Icons.check_rounded, color: Colors.white, size: size * 0.28)
            else if (status == QuadrantStatus.incorrect)
              Icon(Icons.close_rounded, color: Colors.white, size: size * 0.28)
            else if (currentSum > 0)
              Text(
                '$currentSum',
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.black45,
                  height: 1.1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
