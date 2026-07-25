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
      expect(config.gridSize, 10);  // min(4+6, 10)
      expect(config.wordCount, 10); // min(4+6, 20)
      expect(config.timeLimit, 135); // 45+6*15
    });

    test('grid size is capped at 10', () {
      final config = LevelManager.configForLevel(50);
      expect(config.gridSize, 10);
    });

    test('word count is capped at 20', () {
      final config = LevelManager.configForLevel(50);
      expect(config.wordCount, 20);
    });

    test('time limit decreases for levels > 16 (phase 3)', () {
      // Level 17: 285 - (17-16)*2 = 283
      final config17 = LevelManager.configForLevel(17);
      expect(config17.timeLimit, 283);
      // Level 100: 285 - (100-16)*2 = 285 - 168 = 117
      final config100 = LevelManager.configForLevel(100);
      expect(config100.timeLimit, 117);
      // Level 200: 285 - (200-16)*2 = 285 - 368 = -83 → clamped to 45
      final config200 = LevelManager.configForLevel(200);
      expect(config200.timeLimit, 45);
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
