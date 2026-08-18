// Logic: QuadsumGenerator — deterministic generator and solver for 3x3 Quadsum puzzles
import 'dart:math';
import '../models/quadsum_level_config.dart';

class QuadsumGenerator {
  QuadsumGenerator._();

  /// Generates a [QuadsumLevelConfig] deterministically for [level].
  static QuadsumLevelConfig generate({
    required int level,
    required int revealedCount,
    required int timeLimit,
    required String difficulty,
  }) {
    final random = Random(level * 73 + 2039);

    // 1. Generate full valid 3x3 permutation of digits 1..9
    final digits = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(random);
    final solution = [
      [digits[0], digits[1], digits[2]],
      [digits[3], digits[4], digits[5]],
      [digits[6], digits[7], digits[8]],
    ];

    // 2. Compute the 4 quadrant intersection sums
    final sumTL = solution[0][0] + solution[0][1] + solution[1][0] + solution[1][1];
    final sumTR = solution[0][1] + solution[0][2] + solution[1][1] + solution[1][2];
    final sumBL = solution[1][0] + solution[1][1] + solution[2][0] + solution[2][1];
    final sumBR = solution[1][1] + solution[1][2] + solution[2][1] + solution[2][2];

    // 3. Choose starting clues
    final allCellIndices = List<int>.generate(9, (i) => i)..shuffle(random);
    final initialGrid = List.generate(3, (_) => List.filled(3, 0));

    // Reveal target count of cells
    final targetReveals = revealedCount.clamp(2, 6);
    for (int i = 0; i < targetReveals; i++) {
      final cellIdx = allCellIndices[i];
      final r = cellIdx ~/ 3;
      final c = cellIdx % 3;
      initialGrid[r][c] = solution[r][c];
    }

    return QuadsumLevelConfig(
      level: level,
      solution: solution,
      initialGrid: initialGrid,
      sumTopLeft: sumTL,
      sumTopRight: sumTR,
      sumBottomLeft: sumBL,
      sumBottomRight: sumBR,
      timeLimit: timeLimit,
      revealedCount: targetReveals,
      difficulty: difficulty,
    );
  }

  /// Validates whether a given 3x3 grid is a complete, correct Quadsum solution.
  static bool isCompleteSolution({
    required List<List<int>> grid,
    required int sumTL,
    required int sumTR,
    required int sumBL,
    required int sumBR,
  }) {
    final used = <int>{};
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        final val = grid[r][c];
        if (val < 1 || val > 9 || used.contains(val)) {
          return false;
        }
        used.add(val);
      }
    }
    if (used.length != 9) return false;

    if (grid[0][0] + grid[0][1] + grid[1][0] + grid[1][1] != sumTL) return false;
    if (grid[0][1] + grid[0][2] + grid[1][1] + grid[1][2] != sumTR) return false;
    if (grid[1][0] + grid[1][1] + grid[2][0] + grid[2][1] != sumBL) return false;
    if (grid[1][1] + grid[1][2] + grid[2][1] + grid[2][2] != sumBR) return false;

    return true;
  }
}
