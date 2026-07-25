// Widgets: GridPainter — CustomPainter for swipe highlight + found word lines
import 'package:flutter/material.dart';
import '../models/word_entry.dart';
import '../utils/constants.dart';

class GridPainter extends CustomPainter {
  final int gridSize;
  final double cellSize;
  final List<List<int>> highlightedCells;
  final List<WordEntry> foundWords;
  final bool isDark;

  GridPainter({
    required this.gridSize,
    required this.cellSize,
    required this.highlightedCells,
    required this.foundWords,
    required this.isDark,
  });

  Offset _cellCenter(int row, int col) {
    return Offset(
      col * cellSize + cellSize / 2,
      row * cellSize + cellSize / 2,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw found-word permanent lines
    for (final word in foundWords) {
      if (!word.isFound || word.cells.isEmpty) continue;
      final color = AppConstants.wordColors[
          (word.colorIndex ?? 0) % AppConstants.wordColors.length];

      final paint = Paint()
        ..color = color.withValues(alpha: 0.55)
        ..strokeWidth = cellSize * 0.72
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final first = word.cells.first;
      final last = word.cells.last;
      canvas.drawLine(
        _cellCenter(first[0], first[1]),
        _cellCenter(last[0], last[1]),
        paint,
      );
    }

    // Draw live swipe highlight
    if (highlightedCells.isNotEmpty) {
      final highlightPaint = Paint()
        ..color = (isDark
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF6C63FF))
            .withValues(alpha: 0.28)
        ..strokeWidth = cellSize * 0.72
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (highlightedCells.length == 1) {
        final c = highlightedCells.first;
        canvas.drawCircle(
          _cellCenter(c[0], c[1]),
          cellSize * 0.36,
          Paint()
            ..color = (isDark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF6C63FF))
                .withValues(alpha: 0.28)
            ..style = PaintingStyle.fill,
        );
      } else {
        final first = highlightedCells.first;
        final last = highlightedCells.last;
        canvas.drawLine(
          _cellCenter(first[0], first[1]),
          _cellCenter(last[0], last[1]),
          highlightPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.highlightedCells != highlightedCells ||
        oldDelegate.foundWords != foundWords ||
        oldDelegate.isDark != isDark;
  }
}
