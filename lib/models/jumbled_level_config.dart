// Models: JumbledLevelConfig — configuration for each Jumbled Words level
class JumbledLevelConfig {
  final int level;
  final List<String> targetWords;
  final int timeLimit; // in seconds
  final String category;

  const JumbledLevelConfig({
    required this.level,
    required this.targetWords,
    required this.timeLimit,
    required this.category,
  });

  @override
  String toString() =>
      'JumbledLevelConfig(level=$level, words=${targetWords.length}, time=$timeLimit s)';
}
