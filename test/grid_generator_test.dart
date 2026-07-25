// Unit tests: GridGenerator
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/grid_generator.dart';

void main() {
  group('GridGenerator', () {
    test('generates grid of correct size', () {
      final result = GridGenerator(
        gridSize: 8,
        words: ['LION', 'TIGER', 'BEAR', 'WOLF', 'EAGLE'],
        random: Random(42),
      ).generate();

      expect(result.grid.length, 8);
      for (final row in result.grid) {
        expect(row.length, 8);
      }
    });

    test('all cells are filled with a letter', () {
      final result = GridGenerator(
        gridSize: 6,
        words: ['CAT', 'DOG', 'COW'],
        random: Random(1),
      ).generate();

      for (final row in result.grid) {
        for (final cell in row) {
          expect(cell.isNotEmpty, isTrue,
              reason: 'Cell should not be empty');
          expect(cell.length, 1);
        }
      }
    });

    test('placed words are actually in the grid', () {
      final words = ['SNAKE', 'FROG', 'DEER'];
      final result = GridGenerator(
        gridSize: 7,
        words: words,
        random: Random(99),
      ).generate();

      for (final entry in result.placedWords) {
        final sb = StringBuffer();
        for (final cell in entry.cells) {
          sb.write(result.grid[cell[0]][cell[1]]);
        }
        expect(sb.toString(), entry.word,
            reason: 'Word ${entry.word} should be readable in grid');
      }
    });

    test('no conflicting overlaps between different words', () {
      final words = ['APPLE', 'MANGO', 'GRAPE', 'PEACH', 'PLUM'];
      final result = GridGenerator(
        gridSize: 8,
        words: words,
        random: Random(7),
      ).generate();

      // Verify no two words share a cell with a different letter
      final cellMap = <String, String>{};
      for (final entry in result.placedWords) {
        for (int i = 0; i < entry.cells.length; i++) {
          final key = '${entry.cells[i][0]},${entry.cells[i][1]}';
          final letter = entry.word[i];
          if (cellMap.containsKey(key)) {
            expect(cellMap[key], letter,
                reason: 'Cell $key has conflicting letters');
          } else {
            cellMap[key] = letter;
          }
        }
      }
    });

    test('words fit within grid bounds', () {
      final result = GridGenerator(
        gridSize: 5,
        words: ['CAT', 'DOG', 'FOX', 'OWL'],
        random: Random(0),
      ).generate();

      for (final entry in result.placedWords) {
        for (final cell in entry.cells) {
          expect(cell[0], greaterThanOrEqualTo(0));
          expect(cell[0], lessThan(5));
          expect(cell[1], greaterThanOrEqualTo(0));
          expect(cell[1], lessThan(5));
        }
      }
    });
  });
}
