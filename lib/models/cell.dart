// Models: Cell — represents a single cell in the word search grid
class Cell {
  final int row;
  final int col;
  final String letter;
  bool isHighlighted;
  bool isFound;
  int? foundColorIndex; // which found-word color to use

  Cell({
    required this.row,
    required this.col,
    required this.letter,
    this.isHighlighted = false,
    this.isFound = false,
    this.foundColorIndex,
  });

  Cell copyWith({
    String? letter,
    bool? isHighlighted,
    bool? isFound,
    int? foundColorIndex,
  }) {
    return Cell(
      row: row,
      col: col,
      letter: letter ?? this.letter,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isFound: isFound ?? this.isFound,
      foundColorIndex: foundColorIndex ?? this.foundColorIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'Cell($row,$col,$letter)';
}
