// Models: LevelConfig — configuration for each game level
class LevelConfig {
  final int level;
  final int gridSize;
  final int wordCount;
  final int timeLimit; // in seconds
  final String category;

  const LevelConfig({
    required this.level,
    required this.gridSize,
    required this.wordCount,
    required this.timeLimit,
    required this.category,
  });

  @override
  String toString() =>
      'LevelConfig(level=$level, grid=$gridSize×$gridSize, words=$wordCount, time=$timeLimit s)';
}
