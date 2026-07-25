// Widgets: GridWidget — renders the letter grid with gesture + painter overlay
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/word_validator.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import 'grid_painter.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridSize = game.grid.length;
    if (gridSize == 0) return const SizedBox.shrink();

    return LayoutBuilder(builder: (context, constraints) {
      final availableSize = constraints.maxWidth;
      final rawCell = (availableSize - AppConstants.gridPadding * 2) / gridSize;
      final cellSize =
          rawCell.clamp(AppConstants.minCellSize, AppConstants.maxCellSize);
      final gridPixelSize = cellSize * gridSize;

      return Center(
        child: SizedBox(
          width: gridPixelSize,
          height: gridPixelSize,
          child: GestureDetector(
            onPanStart: (details) => _onPanStart(context, details, cellSize, gridSize),
            onPanUpdate: (details) => _onPanUpdate(context, details, cellSize, gridSize),
            onPanEnd: (_) => context.read<GameProvider>().onSwipeEnd(),
            child: Stack(
              children: [
                // ── Letter grid ───────────────────────────────────────────
                _buildLetterGrid(game, gridSize, cellSize, isDark),
                // ── Painter overlay ───────────────────────────────────────
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(
                      gridSize: gridSize,
                      cellSize: cellSize,
                      highlightedCells: game.highlightedCells,
                      foundWords: game.words.where((w) => w.isFound).toList(),
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLetterGrid(
      GameProvider game, int gridSize, double cellSize, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(gridSize, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(gridSize, (col) {
            return _LetterCell(
              letter: game.grid[row][col],
              row: row,
              col: col,
              cellSize: cellSize,
              isHighlighted: game.highlightedCells
                  .any((c) => c[0] == row && c[1] == col),
              isDark: isDark,
            );
          }),
        );
      }),
    );
  }

  void _onPanStart(
      BuildContext context, DragStartDetails details, double cellSize, int gridSize) {
    final cell = WordValidator.offsetToCell(
      dx: details.localPosition.dx,
      dy: details.localPosition.dy,
      cellSize: cellSize,
      gridSize: gridSize,
    );
    if (cell != null) {
      context.read<GameProvider>().onSwipeStart(cell);
    }
  }

  void _onPanUpdate(
      BuildContext context, DragUpdateDetails details, double cellSize, int gridSize) {
    final cell = WordValidator.offsetToCell(
      dx: details.localPosition.dx,
      dy: details.localPosition.dy,
      cellSize: cellSize,
      gridSize: gridSize,
    );
    if (cell != null) {
      context.read<GameProvider>().onSwipeUpdate(cell);
    }
  }
}

class _LetterCell extends StatelessWidget {
  final String letter;
  final int row;
  final int col;
  final double cellSize;
  final bool isHighlighted;
  final bool isDark;

  const _LetterCell({
    required this.letter,
    required this.row,
    required this.col,
    required this.cellSize,
    required this.isHighlighted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isHighlighted
        ? Colors.white
        : (isDark ? const Color(0xFFE8E9FF) : const Color(0xFF1A1B2E));

    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: AppConstants.cellHighlightDuration,
          style: TextStyle(
            fontSize: cellSize * 0.38,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0,
          ),
          child: Text(letter),
        ),
      ),
    );
  }
}
