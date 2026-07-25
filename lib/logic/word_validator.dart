// Logic: WordValidator — validates swipe paths against placed words
import '../models/word_entry.dart';

class WordValidator {
  /// Given a list of [row, col] swipe cells and the list of [WordEntry]s,
  /// returns the matching [WordEntry] if found, or null.
  static WordEntry? validateSwipe({
    required List<List<int>> swipeCells,
    required List<WordEntry> wordEntries,
  }) {
    if (swipeCells.length < 2) return null;

    for (final entry in wordEntries) {
      if (entry.isFound) continue;
      if (_cellsMatchWord(swipeCells, entry)) {
        return entry;
      }
    }
    return null;
  }

  /// Returns true if [swipeCells] exactly matches the word's cells
  /// (in either forward or reverse direction).
  static bool _cellsMatchWord(List<List<int>> swipeCells, WordEntry entry) {
    final wordCells = entry.cells;
    if (swipeCells.length != wordCells.length) return false;

    // Forward match
    bool forward = true;
    for (int i = 0; i < wordCells.length; i++) {
      if (swipeCells[i][0] != wordCells[i][0] ||
          swipeCells[i][1] != wordCells[i][1]) {
        forward = false;
        break;
      }
    }
    if (forward) return true;

    // Reverse match
    bool reverse = true;
    final reversed = wordCells.reversed.toList();
    for (int i = 0; i < reversed.length; i++) {
      if (swipeCells[i][0] != reversed[i][0] ||
          swipeCells[i][1] != reversed[i][1]) {
        reverse = false;
        break;
      }
    }
    return reverse;
  }

  /// Determines if all words have been found → game won.
  static bool isWinCondition(List<WordEntry> wordEntries) {
    return wordEntries.isNotEmpty && wordEntries.every((e) => e.isFound);
  }

  /// Given touch offset and cell size, returns [row, col] index.
  static List<int>? offsetToCell({
    required double dx,
    required double dy,
    required double cellSize,
    required int gridSize,
  }) {
    final col = (dx / cellSize).floor();
    final row = (dy / cellSize).floor();
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) return null;
    return [row, col];
  }

  /// Computes cells along a straight line from [start] to [end].
  /// Returns null if the path is not straight (horizontal, vertical, diagonal).
  static List<List<int>>? cellsBetween(List<int> start, List<int> end) {
    final dr = end[0] - start[0];
    final dc = end[1] - start[1];

    // Must be straight or diagonal
    final absDr = dr.abs();
    final absDc = dc.abs();

    bool isStraight = dr == 0 || dc == 0 || absDr == absDc;
    if (!isStraight) return null;

    final steps = absDr > absDc ? absDr : absDc;
    if (steps == 0) return [start];

    final stepR = dr == 0 ? 0 : dr ~/ absDr;
    final stepC = dc == 0 ? 0 : dc ~/ absDc;

    final cells = <List<int>>[];
    for (int i = 0; i <= steps; i++) {
      cells.add([start[0] + stepR * i, start[1] + stepC * i]);
    }
    return cells;
  }
}
