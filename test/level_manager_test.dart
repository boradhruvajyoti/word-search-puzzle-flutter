// Unit tests: LevelManager
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/level_manager.dart';

void main() {
  group('LevelManager.configForLevel', () {
    test('Levels 1-20: 5x5 grid, 5 words', () {
      final config1 = LevelManager.configForLevel(1);
      expect(config1.gridSize, 5);
      expect(config1.wordCount, 5);

      final config20 = LevelManager.configForLevel(20);
      expect(config20.gridSize, 5);
      expect(config20.wordCount, 5);
    });

    test('Levels 21-40: 6x6 grid, 7 words', () {
      final config21 = LevelManager.configForLevel(21);
      expect(config21.gridSize, 6);
      expect(config21.wordCount, 7);

      final config40 = LevelManager.configForLevel(40);
      expect(config40.gridSize, 6);
      expect(config40.wordCount, 7);
    });

    test('Levels 41-100: 7x7 grid, 9 words', () {
      final config41 = LevelManager.configForLevel(41);
      expect(config41.gridSize, 7);
      expect(config41.wordCount, 9);

      final config100 = LevelManager.configForLevel(100);
      expect(config100.gridSize, 7);
      expect(config100.wordCount, 9);
    });

    test('Levels 101-200: 8x8 grid, 11 words', () {
      final config101 = LevelManager.configForLevel(101);
      expect(config101.gridSize, 8);
      expect(config101.wordCount, 11);

      final config200 = LevelManager.configForLevel(200);
      expect(config200.gridSize, 8);
      expect(config200.wordCount, 11);
    });

    test('Levels 201-500: 9x9 grid, 13 words', () {
      final config201 = LevelManager.configForLevel(201);
      expect(config201.gridSize, 9);
      expect(config201.wordCount, 13);

      final config500 = LevelManager.configForLevel(500);
      expect(config500.gridSize, 9);
      expect(config500.wordCount, 13);
    });

    test('Levels 501-750: 10x10 grid, 15 words', () {
      final config501 = LevelManager.configForLevel(501);
      expect(config501.gridSize, 10);
      expect(config501.wordCount, 15);

      final config750 = LevelManager.configForLevel(750);
      expect(config750.gridSize, 10);
      expect(config750.wordCount, 15);
    });

    test('Levels 751-1000: 10x10 grid, 20 words', () {
      final config751 = LevelManager.configForLevel(751);
      expect(config751.gridSize, 10);
      expect(config751.wordCount, 20);

      final config1000 = LevelManager.configForLevel(1000);
      expect(config1000.gridSize, 10);
      expect(config1000.wordCount, 20);
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
