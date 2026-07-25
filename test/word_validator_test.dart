// Unit tests: WordValidator
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/word_validator.dart';
import 'package:word_search_puzzle/models/word_entry.dart';

WordEntry _makeEntry(String word, List<List<int>> cells) {
  return WordEntry(
    word: word,
    startRow: cells.first[0],
    startCol: cells.first[1],
    direction: 0,
    cells: cells,
  );
}

void main() {
  group('WordValidator.cellsBetween', () {
    test('horizontal straight line', () {
      final cells = WordValidator.cellsBetween([0, 0], [0, 4]);
      expect(cells, [
        [0, 0], [0, 1], [0, 2], [0, 3], [0, 4]
      ]);
    });

    test('vertical straight line', () {
      final cells = WordValidator.cellsBetween([0, 2], [3, 2]);
      expect(cells, [
        [0, 2], [1, 2], [2, 2], [3, 2]
      ]);
    });

    test('diagonal down-right', () {
      final cells = WordValidator.cellsBetween([0, 0], [2, 2]);
      expect(cells, [
        [0, 0], [1, 1], [2, 2]
      ]);
    });

    test('returns null for non-straight path', () {
      final cells = WordValidator.cellsBetween([0, 0], [2, 3]);
      expect(cells, isNull);
    });
  });

  group('WordValidator.validateSwipe', () {
    final entries = [
      _makeEntry('CAT', [[0, 0], [0, 1], [0, 2]]),
      _makeEntry('DOG', [[1, 0], [2, 1], [3, 2]]),
    ];

    test('matches forward swipe', () {
      final matched = WordValidator.validateSwipe(
        swipeCells: [[0, 0], [0, 1], [0, 2]],
        wordEntries: entries,
      );
      expect(matched?.word, 'CAT');
    });

    test('matches reverse swipe', () {
      final matched = WordValidator.validateSwipe(
        swipeCells: [[0, 2], [0, 1], [0, 0]],
        wordEntries: entries,
      );
      expect(matched?.word, 'CAT');
    });

    test('no match for wrong path', () {
      final matched = WordValidator.validateSwipe(
        swipeCells: [[0, 0], [0, 1]],
        wordEntries: entries,
      );
      expect(matched, isNull);
    });

    test('already found word is not returned again', () {
      final alreadyFound = [
        _makeEntry('CAT', [[0, 0], [0, 1], [0, 2]])
          ..isFound = true,
      ];
      final matched = WordValidator.validateSwipe(
        swipeCells: [[0, 0], [0, 1], [0, 2]],
        wordEntries: alreadyFound,
      );
      expect(matched, isNull);
    });
  });

  group('WordValidator.isWinCondition', () {
    test('returns true when all words found', () {
      final words = [
        _makeEntry('CAT', [[0, 0], [0, 1], [0, 2]])..isFound = true,
        _makeEntry('DOG', [[1, 0], [1, 1], [1, 2]])..isFound = true,
      ];
      expect(WordValidator.isWinCondition(words), isTrue);
    });

    test('returns false when some words not found', () {
      final words = [
        _makeEntry('CAT', [[0, 0], [0, 1], [0, 2]])..isFound = true,
        _makeEntry('DOG', [[1, 0], [1, 1], [1, 2]]),
      ];
      expect(WordValidator.isWinCondition(words), isFalse);
    });

    test('returns false for empty list', () {
      expect(WordValidator.isWinCondition([]), isFalse);
    });
  });

  group('WordValidator.offsetToCell', () {
    test('correctly maps offset to cell', () {
      final cell = WordValidator.offsetToCell(
        dx: 55.0,
        dy: 110.0,
        cellSize: 40.0,
        gridSize: 8,
      );
      expect(cell, [2, 1]); // row=2, col=1
    });

    test('returns null for out-of-bounds offset', () {
      final cell = WordValidator.offsetToCell(
        dx: -5.0,
        dy: 20.0,
        cellSize: 40.0,
        gridSize: 8,
      );
      expect(cell, isNull);
    });
  });
}
