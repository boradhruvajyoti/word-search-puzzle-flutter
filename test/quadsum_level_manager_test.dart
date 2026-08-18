// Unit tests: QuadsumLevelManager
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/quadsum_level_manager.dart';

void main() {
  group('QuadsumLevelManager.configForLevel', () {
    test('Level 1: Beginner with 4 clues, 120s', () {
      final config = QuadsumLevelManager.configForLevel(1);
      expect(config.level, 1);
      expect(config.revealedCount, 4);
      expect(config.timeLimit, 120);
      expect(config.difficulty, 'Beginner');
    });

    test('Level 30: Easy with 4 clues, 150s', () {
      final config = QuadsumLevelManager.configForLevel(30);
      expect(config.level, 30);
      expect(config.revealedCount, 4);
      expect(config.timeLimit, 150);
      expect(config.difficulty, 'Easy');
    });

    test('Level 80: Easy-Medium with 3 clues, 180s', () {
      final config = QuadsumLevelManager.configForLevel(80);
      expect(config.level, 80);
      expect(config.revealedCount, 3);
      expect(config.timeLimit, 180);
      expect(config.difficulty, 'Easy-Medium');
    });

    test('Level 150: Medium with 3 clues, 210s', () {
      final config = QuadsumLevelManager.configForLevel(150);
      expect(config.level, 150);
      expect(config.revealedCount, 3);
      expect(config.timeLimit, 210);
      expect(config.difficulty, 'Medium');
    });

    test('Level 300: Medium-Hard with 2 clues, 240s', () {
      final config = QuadsumLevelManager.configForLevel(300);
      expect(config.level, 300);
      expect(config.revealedCount, 2);
      expect(config.timeLimit, 240);
      expect(config.difficulty, 'Medium-Hard');
    });

    test('Level 600: Hard with 2 clues, 270s', () {
      final config = QuadsumLevelManager.configForLevel(600);
      expect(config.level, 600);
      expect(config.revealedCount, 2);
      expect(config.timeLimit, 270);
      expect(config.difficulty, 'Hard');
    });

    test('Level 1000: Master with 2 clues, 300s', () {
      final config = QuadsumLevelManager.configForLevel(1000);
      expect(config.level, 1000);
      expect(config.revealedCount, 2);
      expect(config.timeLimit, 300);
      expect(config.difficulty, 'Master');
    });

    test('asserts on invalid level 0', () {
      expect(() => QuadsumLevelManager.configForLevel(0), throwsAssertionError);
    });
  });

  group('QuadsumLevelManager.starsEarned', () {
    test('3 stars for 60%+ time remaining', () {
      expect(QuadsumLevelManager.starsEarned(120, 180), 3);
    });

    test('2 stars for 30-60% time remaining', () {
      expect(QuadsumLevelManager.starsEarned(70, 180), 2);
    });

    test('1 star for under 30% time remaining', () {
      expect(QuadsumLevelManager.starsEarned(30, 180), 1);
    });
  });
}
