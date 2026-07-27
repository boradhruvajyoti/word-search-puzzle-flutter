// Logic: GridGenerator — places words in the grid and fills remaining cells with native language letters
import 'dart:math';
import '../models/word_entry.dart';

class GridGenerator {
  final int gridSize;
  final List<String> words;
  final String languageCode;
  final Random _random;

  late List<List<String>> _grid;
  late List<WordEntry> _placedWords;

  GridGenerator({
    required this.gridSize,
    required this.words,
    this.languageCode = 'en',
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

  // Native character alphabets for empty cell filling per language
  static const Map<String, String> _languageAlphabets = {
    'ar': 'ابتثجحخدذرزسشصضطظعغفقكلمنهوي',
    'as': 'অআইঈউঊঋএঐওঔকখগঘঙচছজঝঞটঠডঢণতথদধনপফবভমযৰলৱশষসহড়ঢ়য়',
    'bn': 'অআইঈউঊঋএঐওঔকখগঘঙচছজঝঞটঠডঢণতথদধনপফবভমযরলবশষসহড়ঢ়য়',
    'zh': '狮虎象兔猫狗果日月星云风雨雪海山林花鸟鱼爱和美朋友家校国学工成梦文',
    'nl': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'en': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'fr': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'de': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'gu': 'અઆઇઈઉઊઋએઐઓઔકખગઘઙચછજઝઞટઠડઢણતથદધનપફબભમયરલવશષસહળ',
    'hi': 'अआइईउऊऋएऐओऔकखगघङचछजझञटठडढणतथदधनपफबभमयरलवशषसह',
    'id': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'it': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'ja': 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん',
    'ko': '가나다라마바사아자차카타파하거너더러머버서어저처커터퍼허고노도로모보소오조초코토포호구누두루무부수우주추쿠투푸후',
    'pt': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'pa': 'ੳਅੲਸਹਕਖਗਘਙਚਛਜਝਞਟਠਡਢਣਤਥਦਧਨਪਫਬਭਮਯਰਲਵੜ',
    'ru': 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
    'es': 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ',
    'ta': 'அஆஇஈஉஊஎஏஐஒஓஔகஙசஞடணதநபமயரலவழளறன',
    'tr': 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ',
  };

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

  List<String> _toChars(String str) {
    return str.runes.map((r) => String.fromCharCode(r)).toList();
  }

  bool _tryPlaceWord(String word, int colorIdx) {
    final chars = _toChars(word);
    final directions = List<int>.generate(8, (i) => i)..shuffle(_random);

    for (final dir in directions) {
      final positions = _allStartPositions(chars.length, dir);
      positions.shuffle(_random);

      for (final pos in positions) {
        if (_canPlace(chars, pos[0], pos[1], dir)) {
          _placeWord(word, chars, pos[0], pos[1], dir, colorIdx);
          return true;
        }
      }
    }
    return false;
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

  bool _canPlace(List<String> chars, int startRow, int startCol, int dir) {
    final dRow = _deltas[dir][0];
    final dCol = _deltas[dir][1];

    for (int i = 0; i < chars.length; i++) {
      final r = startRow + dRow * i;
      final c = startCol + dCol * i;
      final existing = _grid[r][c];
      if (existing.isNotEmpty && existing != chars[i]) {
        return false; // Conflict
      }
    }
    return true;
  }

  void _placeWord(String word, List<String> chars, int startRow, int startCol, int dir, int colorIdx) {
    final dRow = _deltas[dir][0];
    final dCol = _deltas[dir][1];
    final cells = <List<int>>[];

    for (int i = 0; i < chars.length; i++) {
      final r = startRow + dRow * i;
      final c = startCol + dCol * i;
      _grid[r][c] = chars[i];
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
    final alphabetString =
        _languageAlphabets[languageCode] ?? _languageAlphabets['en']!;
    final alphabetList = _toChars(alphabetString);

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_grid[r][c].isEmpty) {
          _grid[r][c] = alphabetList[_random.nextInt(alphabetList.length)];
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
