// Unit tests: CryptogramLevelManager
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/cryptogram_level_manager.dart';

void main() {
  group('CryptogramLevelManager.configForLevel', () {
    test('Level 1: Beginner with 3 hints, 120s', () {
      final config = CryptogramLevelManager.configForLevel(1);
      expect(config.level, 1);
      expect(config.initialHints, 3);
      expect(config.timeLimit, 120);
      expect(config.difficulty, 'Beginner');
      expect(config.quote.isNotEmpty, isTrue);
      expect(config.author.isNotEmpty, isTrue);
    });

    test('Level 25: Easy with 2 hints, 150s', () {
      final config = CryptogramLevelManager.configForLevel(25);
      expect(config.level, 25);
      expect(config.initialHints, 2);
      expect(config.timeLimit, 150);
      expect(config.difficulty, 'Easy');
    });

    test('Level 50: Easy-Medium with 2 hints, 180s', () {
      final config = CryptogramLevelManager.configForLevel(50);
      expect(config.level, 50);
      expect(config.initialHints, 2);
      expect(config.timeLimit, 180);
      expect(config.difficulty, 'Easy-Medium');
    });

    test('Level 150: Medium with 1 hint, 210s', () {
      final config = CryptogramLevelManager.configForLevel(150);
      expect(config.level, 150);
      expect(config.initialHints, 1);
      expect(config.timeLimit, 210);
      expect(config.difficulty, 'Medium');
    });

    test('Level 300: Medium-Hard with 1 hint, 240s', () {
      final config = CryptogramLevelManager.configForLevel(300);
      expect(config.level, 300);
      expect(config.initialHints, 1);
      expect(config.timeLimit, 240);
      expect(config.difficulty, 'Medium-Hard');
    });

    test('Level 600: Hard with 0 hints, 300s', () {
      final config = CryptogramLevelManager.configForLevel(600);
      expect(config.level, 600);
      expect(config.initialHints, 0);
      expect(config.timeLimit, 300);
      expect(config.difficulty, 'Hard');
    });

    test('Level 1000: Master with 0 hints, 360s', () {
      final config = CryptogramLevelManager.configForLevel(1000);
      expect(config.level, 1000);
      expect(config.initialHints, 0);
      expect(config.timeLimit, 360);
      expect(config.difficulty, 'Master');
      expect(config.quote.isNotEmpty, isTrue);
    });

    test('asserts on invalid level 0', () {
      expect(() => CryptogramLevelManager.configForLevel(0), throwsAssertionError);
    });
  });

  group('CryptogramLevelManager.starsEarned', () {
    test('3 stars for 60%+ time remaining', () {
      expect(CryptogramLevelManager.starsEarned(120, 180), 3); // 66%
    });

    test('2 stars for 30-60% time remaining', () {
      expect(CryptogramLevelManager.starsEarned(70, 180), 2); // 38%
    });

    test('1 star for under 30% time remaining', () {
      expect(CryptogramLevelManager.starsEarned(30, 180), 1); // 16%
    });
  });
}
