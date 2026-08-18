// Models: CryptogramLevelConfig — configuration for each Cryptogram level
class CryptogramLevelConfig {
  final int level;
  final String quote;
  final String author;
  final String category;
  final int timeLimit;
  final int initialHints;
  final String difficulty;

  const CryptogramLevelConfig({
    required this.level,
    required this.quote,
    required this.author,
    required this.category,
    required this.timeLimit,
    required this.initialHints,
    required this.difficulty,
  });

  @override
  String toString() =>
      'CryptogramLevelConfig(level=$level, diff=$difficulty, hints=$initialHints, time=${timeLimit}s)';
}
