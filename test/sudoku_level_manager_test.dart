// Unit tests: SudokuLevelManager
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/sudoku_level_manager.dart';

void main() {
  group('SudokuLevelManager.configForLevel', () {
    test('Level 1 is Very Easy with 65 clues and 180s', () {
      final config1 = SudokuLevelManager.configForLevel(1);
      expect(config1.clueCount, 65);
      expect(config1.timeLimit, 180);
      expect(SudokuLevelManager.difficultyName(1), 'Very Easy');
    });

    test('Levels 1 to 5 gradually decrease clue count', () {
      expect(SudokuLevelManager.configForLevel(1).clueCount, 65);
      expect(SudokuLevelManager.configForLevel(2).clueCount, 63);
      expect(SudokuLevelManager.configForLevel(3).clueCount, 61);
      expect(SudokuLevelManager.configForLevel(4).clueCount, 59);
      expect(SudokuLevelManager.configForLevel(5).clueCount, 57);
    });

    test('Easy tier (Levels 6 to 20)', () {
      expect(SudokuLevelManager.configForLevel(6).clueCount, 55);
      expect(SudokuLevelManager.configForLevel(20).clueCount, 42);
      expect(SudokuLevelManager.difficultyName(6), 'Easy');
    });

    test('Easy-Medium tier (Levels 21 to 40)', () {
      expect(SudokuLevelManager.configForLevel(21).clueCount, 41);
      expect(SudokuLevelManager.configForLevel(40).clueCount, 35);
      expect(SudokuLevelManager.difficultyName(21), 'Easy-Medium');
    });

    test('Medium tier (Levels 41 to 100)', () {
      expect(SudokuLevelManager.configForLevel(41).clueCount, 34);
      expect(SudokuLevelManager.configForLevel(100).clueCount, 30);
      expect(SudokuLevelManager.difficultyName(41), 'Medium');
    });

    test('Master tier (Levels 751 to 1000)', () {
      expect(SudokuLevelManager.configForLevel(751).clueCount, 19);
      expect(SudokuLevelManager.configForLevel(1000).clueCount, 17);
      expect(SudokuLevelManager.difficultyName(1000), 'Master');
    });

    test('asserts on invalid level', () {
      expect(() => SudokuLevelManager.configForLevel(0), throwsAssertionError);
    });
  });
}
