// Tests: JumbledLevelManager unit tests
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/jumbled_level_manager.dart';

void main() {
  group('JumbledLevelManager 7 Phase Difficulty Tests', () {
    test('Phase 1 (Levels 1–20): 2 words, 30s timer', () {
      final config = JumbledLevelManager.configForLevel(10);
      expect(config.targetWords.length, equals(2));
      expect(config.timeLimit, equals(30));
    });

    test('Phase 2 (Levels 21–40): 3 words, 45s timer', () {
      final config = JumbledLevelManager.configForLevel(30);
      expect(config.targetWords.length, equals(3));
      expect(config.timeLimit, equals(45));
    });

    test('Phase 3 (Levels 41–100): 4 words, 60s timer', () {
      final config = JumbledLevelManager.configForLevel(80);
      expect(config.targetWords.length, equals(4));
      expect(config.timeLimit, equals(60));
    });

    test('Phase 4 (Levels 101–200): 5 words, 75s timer', () {
      final config = JumbledLevelManager.configForLevel(150);
      expect(config.targetWords.length, equals(5));
      expect(config.timeLimit, equals(75));
    });

    test('Phase 5 (Levels 201–500): 6 words, 90s timer', () {
      final config = JumbledLevelManager.configForLevel(350);
      expect(config.targetWords.length, equals(6));
      expect(config.timeLimit, equals(90));
    });

    test('Phase 6 (Levels 501–750): 7 words, 105s timer', () {
      final config = JumbledLevelManager.configForLevel(600);
      expect(config.targetWords.length, equals(7));
      expect(config.timeLimit, equals(105));
    });

    test('Phase 7 (Levels 751–1000): 8 words, 120s timer', () {
      final config = JumbledLevelManager.configForLevel(950);
      expect(config.targetWords.length, equals(8));
      expect(config.timeLimit, equals(120));
    });

    test('scrambleWord scrambles characters properly', () {
      const word = 'PUZZLE';
      final scrambled = JumbledLevelManager.scrambleWord(word);
      expect(scrambled.length, equals(word.length));
      expect(scrambled.join(''), isNot(equals(word)));
    });

    test('starsEarned calculates stars based on ratio', () {
      expect(JumbledLevelManager.starsEarned(20, 30), equals(3)); // 66% => 3 stars
      expect(JumbledLevelManager.starsEarned(10, 30), equals(2)); // 33% => 2 stars
      expect(JumbledLevelManager.starsEarned(5, 30), equals(1));  // <30% => 1 star
    });
  });
}
