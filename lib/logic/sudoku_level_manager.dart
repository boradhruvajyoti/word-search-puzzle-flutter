// Logic: SudokuLevelManager — formula-based level config for 1000 Sudoku levels with gradual difficulty progression
import '../models/sudoku_level_config.dart';

class SudokuLevelManager {
  /// Generates a [SudokuLevelConfig] for the given [level] (1-indexed, 1–1000+).
  ///
  /// Difficulty is controlled by clue count (pre-filled cells out of 81).
  /// Level 1 starts very easy with 65 pre-filled clues (only 16 missing numbers)
  /// and difficulty smoothly increases level by level.
  ///
  /// Level tiers:
  ///  Levels 1–5:    Very Easy   — 65 → 57 clues (16–24 blanks), 180s
  ///  Levels 6–20:   Easy        — 55 → 42 clues (26–39 blanks), 180s
  ///  Levels 21–40:  Easy-Med    — 41 → 35 clues (40–46 blanks), 210s
  ///  Levels 41–100: Medium      — 34 → 30 clues (47–51 blanks), 240s
  ///  Levels 101–200: Med-Hard   — 29 → 26 clues (52–55 blanks), 300s
  ///  Levels 201–500: Hard       — 25 → 23 clues (56–58 blanks), 360s
  ///  Levels 501–750: Expert     — 22 → 20 clues (59–61 blanks), 420s
  ///  Levels 751–1000: Master    — 19 → 17 clues (62–64 blanks), 480s
  static SudokuLevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');

    final int clueCount;
    final int timeLimit;

    if (level <= 5) {
      // Very Easy — smooth gentle introduction for beginners
      clueCount = 65 - (level - 1) * 2;
      timeLimit = 180;
    } else if (level <= 20) {
      // Easy (55 down to 42 clues)
      final t = (level - 6) / (20 - 6);
      clueCount = (55 - t * 13).round();
      timeLimit = 180;
    } else if (level <= 40) {
      // Easy-Medium (41 down to 35 clues)
      final t = (level - 21) / (40 - 21);
      clueCount = (41 - t * 6).round();
      timeLimit = 210;
    } else if (level <= 100) {
      // Medium (34 down to 30 clues)
      final t = (level - 41) / (100 - 41);
      clueCount = (34 - t * 4).round();
      timeLimit = 240;
    } else if (level <= 200) {
      // Medium-Hard (29 down to 26 clues)
      final t = (level - 101) / (200 - 101);
      clueCount = (29 - t * 3).round();
      timeLimit = 300;
    } else if (level <= 500) {
      // Hard (25 down to 23 clues)
      final t = (level - 201) / (500 - 201);
      clueCount = (25 - t * 2).round();
      timeLimit = 360;
    } else if (level <= 750) {
      // Expert (22 down to 20 clues)
      final t = (level - 501) / (750 - 501);
      clueCount = (22 - t * 2).round();
      timeLimit = 420;
    } else {
      // Master (19 down to 17 clues)
      final t = (level - 751) / (1000 - 751);
      clueCount = (19 - t * 2).clamp(17, 19).round();
      timeLimit = 480;
    }

    return SudokuLevelConfig(
      level: level,
      clueCount: clueCount,
      timeLimit: timeLimit,
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
  static String levelLabel(int level) => 'Sudoku Level $level';

  /// Difficulty name for the given level.
  static String difficultyName(int level) {
    if (level <= 5) return 'Very Easy';
    if (level <= 20) return 'Easy';
    if (level <= 40) return 'Easy-Medium';
    if (level <= 100) return 'Medium';
    if (level <= 200) return 'Medium-Hard';
    if (level <= 500) return 'Hard';
    if (level <= 750) return 'Expert';
    return 'Master';
  }
}
