// Unit tests: LevelManager
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/level_manager.dart';

void main() {
  group('LevelManager.configForLevel', () {
    test('level 1 returns correct config', () {
      final config = LevelManager.configForLevel(1);
      expect(config.level, 1);
      expect(config.gridSize, 5); // min(4+1, 15)
      expect(config.wordCount, 5); // min(4+1, 20)
      expect(config.timeLimit, 60); // 45 + 1*15
    });

    test('level 6 returns correct config', () {
      final config = LevelManager.configForLevel(6);
      expect(config.gridSize, 10); // 4+6
      expect(config.wordCount, 10); // 4+6
      expect(config.timeLimit, 135); // 45+6*15
    });

    test('grid size is capped at 15', () {
      final config = LevelManager.configForLevel(50);
      expect(config.gridSize, 15);
    });

    test('word count is capped at 20', () {
      final config = LevelManager.configForLevel(50);
      expect(config.wordCount, 20);
    });

    test('time limit scales correctly for level 10', () {
      final config = LevelManager.configForLevel(10);
      expect(config.timeLimit, 195); // 45 + 10*15
    });

    test('asserts on invalid level', () {
      expect(() => LevelManager.configForLevel(0), throwsAssertionError);
    });
  });

  group('LevelManager.starsEarned', () {
    test('3 stars for 60%+ time remaining', () {
      expect(LevelManager.starsEarned(40, 60), 3); // 66%
    });

    test('2 stars for 30-60% time remaining', () {
      expect(LevelManager.starsEarned(25, 60), 2); // 41%
    });

    test('1 star for under 30% time remaining', () {
      expect(LevelManager.starsEarned(10, 60), 1); // 16%
    });

    test('3 stars for full time remaining', () {
      expect(LevelManager.starsEarned(60, 60), 3);
    });
  });
}
