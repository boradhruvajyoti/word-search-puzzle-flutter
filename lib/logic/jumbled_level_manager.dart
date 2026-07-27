// Logic: JumbledLevelManager — level configuration & word scrambling for Jumbled Words
import 'dart:math';
import '../models/jumbled_level_config.dart';
import 'word_bank.dart';

class JumbledLevelManager {
  /// Generates a [JumbledLevelConfig] for the given [level] (1–1000+).
  static JumbledLevelConfig configForLevel(int level, [String languageCode = 'en']) {
    assert(level >= 1, 'Level must be >= 1');

    final int wordCount;
    final int minLen;
    final int maxLen;
    final int timeLimit;

    if (level <= 20) {
      // Phase 1 (Levels 1–20): 2 words, length 3-4, 30s timer
      wordCount = 2;
      minLen = 3;
      maxLen = 4;
      timeLimit = 30;
    } else if (level <= 40) {
      // Phase 2 (Levels 21–40): 3 words, length 4-5, 45s timer
      wordCount = 3;
      minLen = 4;
      maxLen = 5;
      timeLimit = 45;
    } else if (level <= 100) {
      // Phase 3 (Levels 41–100): 4 words, length 5-6, 60s timer
      wordCount = 4;
      minLen = 5;
      maxLen = 6;
      timeLimit = 60;
    } else if (level <= 200) {
      // Phase 4 (Levels 101–200): 5 words, length 5-7, 75s timer
      wordCount = 5;
      minLen = 5;
      maxLen = 7;
      timeLimit = 75;
    } else if (level <= 500) {
      // Phase 5 (Levels 201–500): 6 words, length 6-8, 90s timer
      wordCount = 6;
      minLen = 6;
      maxLen = 8;
      timeLimit = 90;
    } else if (level <= 750) {
      // Phase 6 (Levels 501–750): 7 words, length 6-9, 105s timer
      wordCount = 7;
      minLen = 6;
      maxLen = 9;
      timeLimit = 105;
    } else {
      // Phase 7 (Levels 751–1000): 8 words, length 7-10, 120s timer
      wordCount = 8;
      minLen = 7;
      maxLen = 10;
      timeLimit = 120;
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
