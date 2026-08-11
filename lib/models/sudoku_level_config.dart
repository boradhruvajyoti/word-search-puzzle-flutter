// Models: SudokuLevelConfig — configuration for each Sudoku level
class SudokuLevelConfig {
  final int level;
  final int clueCount; // number of pre-filled cells (81 - blanks)
  final int timeLimit; // in seconds

  const SudokuLevelConfig({
    required this.level,
    required this.clueCount,
    required this.timeLimit,
  });

  @override
  String toString() =>
      'SudokuLevelConfig(level=$level, clues=$clueCount, time=$timeLimit s)';
}
