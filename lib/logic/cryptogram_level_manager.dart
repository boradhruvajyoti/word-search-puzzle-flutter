// Logic: CryptogramLevelManager — level config generator for 1000 Cryptogram levels
import '../models/cryptogram_level_config.dart';
import 'cryptogram_quotes_bank.dart';

class CryptogramLevelManager {
  CryptogramLevelManager._();

  /// Generates a [CryptogramLevelConfig] for the given [level] (1-indexed, 1–1000+).
  static CryptogramLevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');

    final quoteEntry = CryptogramQuotesBank.getForLevel(level);

    final int initialHints;
    final int timeLimit;
    final String difficulty;

    if (level <= 20) {
      initialHints = 3;
      timeLimit = 120;
      difficulty = 'Beginner';
    } else if (level <= 40) {
      initialHints = 2;
      timeLimit = 150;
      difficulty = 'Easy';
    } else if (level <= 100) {
      initialHints = 2;
      timeLimit = 180;
      difficulty = 'Easy-Medium';
    } else if (level <= 200) {
      initialHints = 1;
      timeLimit = 210;
      difficulty = 'Medium';
    } else if (level <= 500) {
      initialHints = 1;
      timeLimit = 240;
      difficulty = 'Medium-Hard';
    } else if (level <= 750) {
      initialHints = 0;
      timeLimit = 300;
      difficulty = 'Hard';
    } else {
      initialHints = 0;
      timeLimit = 360;
      difficulty = 'Master';
    }

    return CryptogramLevelConfig(
      level: level,
      quote: quoteEntry.quote,
      author: quoteEntry.author,
      category: quoteEntry.category,
      timeLimit: timeLimit,
      initialHints: initialHints,
      difficulty: difficulty,
    );
  }

  /// Stars earned (1–3) based on time remaining vs total time.
  static int starsEarned(int timeRemaining, int timeLimit) {
    if (timeLimit == 0) return 1;
    final ratio = timeRemaining / timeLimit;
    if (ratio >= 0.6) return 3;
    if (ratio >= 0.3) return 2;
    return 1;
  }

  /// Display label for a level.
  static String levelLabel(int level) => 'Cryptogram Level $level';

  /// Difficulty name for the level.
  static String difficultyName(int level) =>
      configForLevel(level).difficulty;
}
