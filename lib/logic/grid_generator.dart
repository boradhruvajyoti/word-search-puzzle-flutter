// Logic: GridGenerator — places words in the grid and fills remaining cells
import 'dart:math';
import '../models/word_entry.dart';

class GridGenerator {
  final int gridSize;
  final List<String> words;
  final Random _random;

  late List<List<String>> _grid;
  late List<WordEntry> _placedWords;

  GridGenerator({
    required this.gridSize,
    required this.words,
    Random? random,
  }) : _random = random ?? Random();

  // Direction deltas: [dRow, dCol] for each PlacementDirection constant
  static const List<List<int>> _deltas = [
    [0, 1],   // horizontal L→R
    [0, -1],  // horizontal R→L
    [1, 0],   // vertical top→bottom
    [-1, 0],  // vertical bottom→top
    [1, 1],   // diagonal down-right
    [1, -1],  // diagonal down-left
    [-1, 1],  // diagonal up-right
    [-1, -1], // diagonal up-left
  ];

  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Generates the grid and returns [GridResult] with placed words and letter matrix.
  GridResult generate() {
    _grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => ''),
    );
    _placedWords = [];

    final shuffledWords = List<String>.from(words)..shuffle(_random);

    for (int colorIdx = 0; colorIdx < shuffledWords.length; colorIdx++) {
      final word = shuffledWords[colorIdx];
      _tryPlaceWord(word, colorIdx);
    }

    _fillEmpty();

    return GridResult(
      grid: _grid.map((row) => List<String>.unmodifiable(row)).toList(),
      placedWords: List.unmodifiable(_placedWords),
    );
  }

  bool _tryPlaceWord(String word, int colorIdx) {
    // Shuffle directions and starting positions for random placement
    final directions = List<int>.generate(8, (i) => i)..shuffle(_random);

    for (final dir in directions) {
      final positions = _allStartPositions(word.length, dir);
      positions.shuffle(_random);

      for (final pos in positions) {
        if (_canPlace(word, pos[0], pos[1], dir)) {
          _placeWord(word, pos[0], pos[1], dir, colorIdx);
          return true;
        }
      }
    }
    return false; // Could not place word
  }

  List<List<int>> _allStartPositions(int length, int dir) {
    final dRow = _deltas[dir][0];
    final dCol = _deltas[dir][1];
    final result = <List<int>>[];

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        final endRow = r + dRow * (length - 1);
        final endCol = c + dCol * (length - 1);
        if (endRow >= 0 && endRow < gridSize && endCol >= 0 && endCol < gridSize) {
          result.add([r, c]);
        }
      }
    }
    return result;
  }

  bool _canPlace(String word, int startRow, int startCol, int dir) {
    final dRow = _deltas[dir][0];
    final dCol = _deltas[dir][1];

    for (int i = 0; i < word.length; i++) {
      final r = startRow + dRow * i;
      final c = startCol + dCol * i;
      final existing = _grid[r][c];
      if (existing.isNotEmpty && existing != word[i]) {
        return false; // Conflict
      }
    }
    return true;
  }

  void _placeWord(String word, int startRow, int startCol, int dir, int colorIdx) {
    final dRow = _deltas[dir][0];
    final dCol = _deltas[dir][1];
    final cells = <List<int>>[];

    for (int i = 0; i < word.length; i++) {
      final r = startRow + dRow * i;
      final c = startCol + dCol * i;
      _grid[r][c] = word[i];
      cells.add([r, c]);
    }

    _placedWords.add(WordEntry(
      word: word,
      startRow: startRow,
      startCol: startCol,
      direction: dir,
      cells: cells,
      colorIndex: colorIdx,
    ));
  }

  void _fillEmpty() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_grid[r][c].isEmpty) {
          _grid[r][c] = _alphabet[_random.nextInt(26)];
        }
      }
    }
  }
}

class GridResult {
  final List<List<String>> grid;
  final List<WordEntry> placedWords;

  const GridResult({required this.grid, required this.placedWords});
}
