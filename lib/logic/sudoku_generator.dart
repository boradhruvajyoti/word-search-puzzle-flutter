// Logic: SudokuGenerator — backtracking puzzle generator and solver
import 'dart:math';

class SudokuResult {
  /// Full solved grid (9×9, values 1–9).
  final List<List<int>> solution;

  /// Puzzle grid with blanks as 0.
  final List<List<int>> puzzle;

  const SudokuResult({required this.solution, required this.puzzle});
}

class SudokuGenerator {
  final int clueCount;
  final int seed;
  late final Random _rng;

  SudokuGenerator({required this.clueCount, int? seed})
      : seed = seed ?? DateTime.now().microsecondsSinceEpoch {
    _rng = Random(seed ?? DateTime.now().microsecondsSinceEpoch);
  }

  /// Generates a valid Sudoku puzzle and its solution.
  SudokuResult generate() {
    final grid = _emptyGrid();
    _fillGrid(grid);

    // Deep-copy solution before punching holes
    final solution = grid.map((row) => List<int>.from(row)).toList();

    // Remove cells to create the puzzle
    _removeDigits(grid, clueCount);

    return SudokuResult(
      solution: solution,
      puzzle: grid,
    );
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  List<List<int>> _emptyGrid() =>
      List.generate(9, (_) => List.filled(9, 0));

  /// Recursively fills the grid using backtracking with randomised digit order.
  bool _fillGrid(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          final digits = List<int>.generate(9, (i) => i + 1)..shuffle(_rng);
          for (final digit in digits) {
            if (_isValid(grid, row, col, digit)) {
              grid[row][col] = digit;
              if (_fillGrid(grid)) return true;
              grid[row][col] = 0;
            }
          }
          return false; // backtrack
        }
      }
    }
    return true; // all cells filled
  }

  /// Returns true if [digit] can be placed at [row][col] without violating rules.
  bool _isValid(List<List<int>> grid, int row, int col, int digit) {
    // Check row
    if (grid[row].contains(digit)) return false;

    // Check column
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == digit) return false;
    }

    // Check 3×3 box
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if (grid[r][c] == digit) return false;
      }
    }

    return true;
  }

  /// Removes (81 - clueCount) random cells from the fully filled grid.
  void _removeDigits(List<List<int>> grid, int clueCount) {
    final blanks = 81 - clueCount;
    final positions = List<int>.generate(81, (i) => i)..shuffle(_rng);

    int removed = 0;
    for (final pos in positions) {
      if (removed >= blanks) break;
      final row = pos ~/ 9;
      final col = pos % 9;
      grid[row][col] = 0;
      removed++;
    }
  }

  /// Checks if a user-filled grid fully matches the solution.
  static bool isSolved(List<List<int>> userGrid, List<List<int>> solution) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (userGrid[r][c] != solution[r][c]) return false;
      }
    }
    return true;
  }
}
