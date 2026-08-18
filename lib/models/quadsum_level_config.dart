// Models: QuadsumLevelConfig — configuration for a Quadsum level
class QuadsumLevelConfig {
  final int level;
  final List<List<int>> solution; // 3x3 complete grid with digits 1..9
  final List<List<int>> initialGrid; // 3x3 grid with 0 for empty cells, 1..9 for locked clues
  final int sumTopLeft; // (0,0) + (0,1) + (1,0) + (1,1)
  final int sumTopRight; // (0,1) + (0,2) + (1,1) + (1,2)
  final int sumBottomLeft; // (1,0) + (1,1) + (2,0) + (2,1)
  final int sumBottomRight; // (1,1) + (1,2) + (2,1) + (2,2)
  final int timeLimit; // in seconds
  final int revealedCount; // number of starting revealed clues
  final String difficulty; // Beginner, Easy, Medium, Hard, Master

  const QuadsumLevelConfig({
    required this.level,
    required this.solution,
    required this.initialGrid,
    required this.sumTopLeft,
    required this.sumTopRight,
    required this.sumBottomLeft,
    required this.sumBottomRight,
    required this.timeLimit,
    required this.revealedCount,
    required this.difficulty,
  });
}
