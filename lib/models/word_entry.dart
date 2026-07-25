// Models: WordEntry — a word placed in the grid
class PlacementDirection {
  static const int horizontal = 0;
  static const int horizontalReverse = 1;
  static const int vertical = 2;
  static const int verticalReverse = 3;
  static const int diagonalDownRight = 4;
  static const int diagonalDownLeft = 5;
  static const int diagonalUpRight = 6;
  static const int diagonalUpLeft = 7;

  static const List<int> all = [
    horizontal,
    horizontalReverse,
    vertical,
    verticalReverse,
    diagonalDownRight,
    diagonalDownLeft,
    diagonalUpRight,
    diagonalUpLeft,
  ];
}

class WordEntry {
  final String word;
  final int startRow;
  final int startCol;
  final int direction;
  final List<List<int>> cells; // [[row, col], ...]
  bool isFound;
  int? colorIndex;

  WordEntry({
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.direction,
    required this.cells,
    this.isFound = false,
    this.colorIndex,
  });

  WordEntry copyWith({bool? isFound, int? colorIndex}) {
    return WordEntry(
      word: word,
      startRow: startRow,
      startCol: startCol,
      direction: direction,
      cells: cells,
      isFound: isFound ?? this.isFound,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  @override
  String toString() => 'WordEntry($word, dir=$direction, found=$isFound)';
}
