// Logic: JumbledLevelManager — level configuration & word scrambling for Jumbled Words
import 'dart:math';
import '../models/jumbled_level_config.dart';
import 'word_bank.dart';

class JumbledLevelManager {
  /// Generates a [JumbledLevelConfig] for the given [level] (1–1000+) and [languageCode].
  static JumbledLevelConfig configForLevel(int level, String languageCode) {
    assert(level >= 1, 'Level must be >= 1');

    final int wordCount;
    final int minLen;
    final int maxLen;
    final int timeLimit;

    if (level <= 50) {
      wordCount = 1;
      minLen = 3;
      maxLen = 5;
      timeLimit = 60;
    } else if (level <= 200) {
      wordCount = 2;
      minLen = 4;
      maxLen = 6;
      timeLimit = 75;
    } else if (level <= 500) {
      wordCount = 3;
      minLen = 5;
      maxLen = 7;
      timeLimit = 90;
    } else if (level <= 750) {
      wordCount = 4;
      minLen = 5;
      maxLen = 8;
      timeLimit = 120;
    } else {
      wordCount = 5;
      minLen = 6;
      maxLen = 10;
      timeLimit = 150;
    }

    final rand = Random(level * 10007 + languageCode.hashCode);

    // Fetch word list from WordBank
    final pool = WordBank.randomWordsForLanguage(maxLen, languageCode);
    final filtered = pool.where((w) {
      final len = w.trim().runes.length;
      return len >= minLen && len <= maxLen;
    }).toList();

    List<String> targetWords = [];
    if (filtered.length >= wordCount) {
      filtered.shuffle(rand);
      targetWords = filtered.take(wordCount).toList();
    } else if (pool.isNotEmpty) {
      pool.shuffle(rand);
      targetWords = pool.take(wordCount).toList();
    } else {
      // Fallback
      targetWords = ['PUZZLE', 'GAME', 'WORD'].take(wordCount).toList();
    }

    // Ensure words are trimmed and uppercase for uniform handling
    targetWords = targetWords.map((w) => w.trim().toUpperCase()).toList();

    return JumbledLevelConfig(
      level: level,
      targetWords: targetWords,
      timeLimit: timeLimit,
      category: 'Jumbled Words',
    );
  }

  /// Helper to convert a string to list of character strings safely (supporting unicode/runes).
  static List<String> wordToChars(String word) {
    return word.runes.map((r) => String.fromCharCode(r)).toList();
  }

  /// Scrambles a word's characters ensuring the output is scrambled (if length > 1).
  static List<String> scrambleWord(String word, [Random? seedRandom]) {
    final chars = wordToChars(word);
    if (chars.length <= 1) return chars;

    final rand = seedRandom ?? Random();
    List<String> scrambled = List.from(chars);

    int attempts = 0;
    while (attempts < 10 && _listsEqual(scrambled, chars)) {
      scrambled.shuffle(rand);
      attempts++;
    }

    // If still matching after attempts, swap first two
    if (_listsEqual(scrambled, chars) && scrambled.length >= 2) {
      final temp = scrambled[0];
      scrambled[0] = scrambled[1];
      scrambled[1] = temp;
    }

    return scrambled;
  }

  static bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Display label for a level.
  static String levelLabel(int level) => 'Level $level';

  /// Stars earned (1–3) based on time remaining vs total time.
  static int starsEarned(int timeRemaining, int timeLimit) {
    if (timeLimit == 0) return 1;
    final ratio = timeRemaining / timeLimit;
    if (ratio >= 0.6) return 3;
    if (ratio >= 0.3) return 2;
    return 1;
  }
}
