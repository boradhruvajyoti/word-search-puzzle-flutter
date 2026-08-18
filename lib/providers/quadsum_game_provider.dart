// Providers: QuadsumGameProvider — game state, keypad/keyboard actions, quadrant sums, and validation
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../logic/quadsum_generator.dart';
import '../logic/quadsum_level_manager.dart';
import '../models/game_state.dart';
import '../models/quadsum_level_config.dart';

enum QuadrantStatus {
  incomplete,
  correct,
  incorrect,
}

class QuadsumGameProvider extends ChangeNotifier {
  int _level = 1;
  QuadsumLevelConfig? _config;
  List<List<int>> _grid = List.generate(3, (_) => List.filled(3, 0));
  final Set<int> _lockedIndices = {}; // cell indices (r * 3 + c) that are locked initial clues

  int _selectedRow = 0;
  int _selectedCol = 0;
  int _movesCount = 0;
  int _errorCount = 0;

  final List<List<List<int>>> _history = []; // Undo stack

  GameStatus _status = GameStatus.idle;
  Timer? _timer;
  int _timeRemaining = 0;

  // ── Getters ────────────────────────────────────────────────────────────────
  int get level => _level;
  QuadsumLevelConfig? get config => _config;
  List<List<int>> get grid => _grid;
  int get selectedRow => _selectedRow;
  int get selectedCol => _selectedCol;
  int get movesCount => _movesCount;
  int get errorCount => _errorCount;
  GameStatus get status => _status;
  int get timeRemaining => _timeRemaining;
  bool get canUndo => _history.isNotEmpty;

  bool isCellLocked(int row, int col) => _lockedIndices.contains(row * 3 + col);

  Set<int> get usedDigits {
    final used = <int>{};
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        final val = _grid[r][c];
        if (val >= 1 && val <= 9) {
          used.add(val);
        }
      }
    }
    return used;
  }

  bool isDigitUsed(int digit) => usedDigits.contains(digit);

  // ── Quadrant Calculations ──────────────────────────────────────────────────
  int get currentSumTopLeft => _grid[0][0] + _grid[0][1] + _grid[1][0] + _grid[1][1];
  int get currentSumTopRight => _grid[0][1] + _grid[0][2] + _grid[1][1] + _grid[1][2];
  int get currentSumBottomLeft => _grid[1][0] + _grid[1][1] + _grid[2][0] + _grid[2][1];
  int get currentSumBottomRight => _grid[1][1] + _grid[1][2] + _grid[2][1] + _grid[2][2];

  bool _isQuadrantFilled(int r1, int c1, int r2, int c2, int r3, int c3, int r4, int c4) {
    return _grid[r1][c1] > 0 && _grid[r2][c2] > 0 && _grid[r3][c3] > 0 && _grid[r4][c4] > 0;
  }

  QuadrantStatus get statusTopLeft {
    if (_config == null) return QuadrantStatus.incomplete;
    final filled = _isQuadrantFilled(0, 0, 0, 1, 1, 0, 1, 1);
    if (!filled) return QuadrantStatus.incomplete;
    return currentSumTopLeft == _config!.sumTopLeft ? QuadrantStatus.correct : QuadrantStatus.incorrect;
  }

  QuadrantStatus get statusTopRight {
    if (_config == null) return QuadrantStatus.incomplete;
    final filled = _isQuadrantFilled(0, 1, 0, 2, 1, 1, 1, 2);
    if (!filled) return QuadrantStatus.incomplete;
    return currentSumTopRight == _config!.sumTopRight ? QuadrantStatus.correct : QuadrantStatus.incorrect;
  }

  QuadrantStatus get statusBottomLeft {
    if (_config == null) return QuadrantStatus.incomplete;
    final filled = _isQuadrantFilled(1, 0, 1, 1, 2, 0, 2, 1);
    if (!filled) return QuadrantStatus.incomplete;
    return currentSumBottomLeft == _config!.sumBottomLeft ? QuadrantStatus.correct : QuadrantStatus.incorrect;
  }

  QuadrantStatus get statusBottomRight {
    if (_config == null) return QuadrantStatus.incomplete;
    final filled = _isQuadrantFilled(1, 1, 1, 2, 2, 1, 2, 2);
    if (!filled) return QuadrantStatus.incomplete;
    return currentSumBottomRight == _config!.sumBottomRight ? QuadrantStatus.correct : QuadrantStatus.incorrect;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  void startLevel(int level) {
    _timer?.cancel();
    _level = level;
    _config = QuadsumLevelManager.configForLevel(level);

    _grid = List.generate(3, (r) => List.generate(3, (c) => _config!.initialGrid[r][c]));
    _lockedIndices.clear();

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (_config!.initialGrid[r][c] > 0) {
          _lockedIndices.add(r * 3 + c);
        }
      }
    }

    _selectedRow = 0;
    _selectedCol = 0;
    _movesCount = 0;
    _errorCount = 0;
    _history.clear();

    // Select first unlocked cell if (0,0) is locked
    if (isCellLocked(0, 0)) {
      _selectFirstUnlockedCell();
    }

    _timeRemaining = _config!.timeLimit;
    _status = GameStatus.playing;

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status != GameStatus.playing) return;
      if (_timeRemaining > 0) {
        _timeRemaining--;
        notifyListeners();
        if (_timeRemaining == 0) {
          _status = GameStatus.lost;
          _timer?.cancel();
          notifyListeners();
        }
      }
    });
  }

  void _selectFirstUnlockedCell() {
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (!isCellLocked(r, c)) {
          _selectedRow = r;
          _selectedCol = c;
          return;
        }
      }
    }
  }

  // ── Input & Navigation ─────────────────────────────────────────────────────
  void selectCell(int row, int col) {
    if (row >= 0 && row < 3 && col >= 0 && col < 3) {
      _selectedRow = row;
      _selectedCol = col;
      notifyListeners();
    }
  }

  void moveSelection(int dRow, int dCol) {
    final newR = (_selectedRow + dRow).clamp(0, 2);
    final newC = (_selectedCol + dCol).clamp(0, 2);
    selectCell(newR, newC);
  }

  void inputDigit(int digit) {
    if (_status != GameStatus.playing || _config == null) return;
    if (digit < 1 || digit > 9) return;
    if (isCellLocked(_selectedRow, _selectedCol)) return;

    if (_grid[_selectedRow][_selectedCol] == digit) return;

    // Save for undo
    _saveHistory();

    _grid[_selectedRow][_selectedCol] = digit;
    _movesCount++;

    // Check completion
    _checkGameState();
    notifyListeners();
  }

  void eraseSelected() {
    if (_status != GameStatus.playing || _config == null) return;
    if (isCellLocked(_selectedRow, _selectedCol)) return;
    if (_grid[_selectedRow][_selectedCol] == 0) return;

    _saveHistory();
    _grid[_selectedRow][_selectedCol] = 0;
    _movesCount++;
    notifyListeners();
  }

  void undo() {
    if (_status != GameStatus.playing || _history.isEmpty) return;
    final previousGrid = _history.removeLast();
    _grid = previousGrid;
    notifyListeners();
  }

  void _saveHistory() {
    _history.add(List.generate(3, (r) => List.generate(3, (c) => _grid[r][c])));
    if (_history.length > 30) {
      _history.removeAt(0);
    }
  }

  bool useHint() {
    if (_status != GameStatus.playing || _config == null) return false;

    // Find empty or wrong cells that are not locked
    final candidateCells = <List<int>>[];
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (!isCellLocked(r, c) && _grid[r][c] != _config!.solution[r][c]) {
          candidateCells.add([r, c]);
        }
      }
    }

    if (candidateCells.isEmpty) return false;

    final random = Random();
    final chosen = candidateCells[random.nextInt(candidateCells.length)];
    final r = chosen[0];
    final c = chosen[1];

    _saveHistory();
    _grid[r][c] = _config!.solution[r][c];
    _lockedIndices.add(r * 3 + c);
    _selectedRow = r;
    _selectedCol = c;
    _movesCount++;

    _checkGameState();
    notifyListeners();
    return true;
  }

  void restart() {
    if (_config == null) return;
    _grid = List.generate(3, (r) => List.generate(3, (c) => _config!.initialGrid[r][c]));
    _lockedIndices.clear();
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (_config!.initialGrid[r][c] > 0) {
          _lockedIndices.add(r * 3 + c);
        }
      }
    }
    _history.clear();
    _movesCount = 0;
    _errorCount = 0;
    notifyListeners();
  }

  void _checkGameState() {
    // Check if full
    bool isFull = true;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (_grid[r][c] == 0) {
          isFull = false;
          break;
        }
      }
    }

    if (!isFull) return;

    final isSolved = QuadsumGenerator.isCompleteSolution(
      grid: _grid,
      sumTL: _config!.sumTopLeft,
      sumTR: _config!.sumTopRight,
      sumBL: _config!.sumBottomLeft,
      sumBR: _config!.sumBottomRight,
    );

    if (isSolved) {
      _status = GameStatus.won;
      _timer?.cancel();
    } else {
      _errorCount++;
    }
  }

  void pause() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void resume() {
    if (_status == GameStatus.paused) {
      _status = GameStatus.playing;
      _startTimer();
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _status = GameStatus.idle;
    _config = null;
    _grid = List.generate(3, (_) => List.filled(3, 0));
    _lockedIndices.clear();
    _history.clear();
    _movesCount = 0;
    _errorCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
