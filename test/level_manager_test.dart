// Unit tests: LevelManager
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/level_manager.dart';

void main() {
  group('LevelManager.configForLevel', () {
    test('Phase 1 grid sizes (5x5 to 6x6)', () {
      expect(LevelManager.configForLevel(1).gridSize, 5);
      expect(LevelManager.configForLevel(10).gridSize, 5);
      expect(LevelManager.configForLevel(11).gridSize, 6);
      expect(LevelManager.configForLevel(20).gridSize, 6);
    });

    test('Phase 2 grid sizes (7x7 to 8x8)', () {
      expect(LevelManager.configForLevel(21).gridSize, 7);
      expect(LevelManager.configForLevel(30).gridSize, 7);
      expect(LevelManager.configForLevel(31).gridSize, 8);
      expect(LevelManager.configForLevel(40).gridSize, 8);
    });

    test('Phase 3 grid size (9x9)', () {
      expect(LevelManager.configForLevel(41).gridSize, 9);
      expect(LevelManager.configForLevel(70).gridSize, 9);
      expect(LevelManager.configForLevel(100).gridSize, 9);
    });

    test('Phase 4 grid size (10x10)', () {
      expect(LevelManager.configForLevel(101).gridSize, 10);
      expect(LevelManager.configForLevel(500).gridSize, 10);
      expect(LevelManager.configForLevel(1000).gridSize, 10);
    });

    test('word count scaling across phases', () {
      expect(LevelManager.configForLevel(1).wordCount, 4);
      expect(LevelManager.configForLevel(20).wordCount, 6);
      expect(LevelManager.configForLevel(40).wordCount, 8);
      expect(LevelManager.configForLevel(100).wordCount, 12);
      expect(LevelManager.configForLevel(1000).wordCount, 20);
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
