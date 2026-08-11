// Providers: SudokuGameProvider — full Sudoku game state with timer and input
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../logic/sudoku_generator.dart';
import '../logic/sudoku_level_manager.dart';
import '../models/game_state.dart';
import '../models/sudoku_level_config.dart';

class SudokuGameProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  GameStatus _status = GameStatus.idle;
  SudokuLevelConfig? _config;

  /// The original puzzle grid (0 = blank, 1-9 = clue).
  List<List<int>> _puzzle = [];

  /// The fully solved reference grid.
  List<List<int>> _solution = [];

  /// The grid that the user is actively filling in.
  List<List<int>> _userGrid = [];

  /// Currently selected cell [row, col], or null.
  List<int>? _selectedCell;

  // Timer
  int _timeRemaining = 0;
  Timer? _timer;

  // ── Getters ────────────────────────────────────────────────────────────────
  GameStatus get status => _status;
  SudokuLevelConfig? get config => _config;
  List<List<int>> get puzzle => _puzzle;
  List<List<int>> get solution => _solution;
  List<List<int>> get userGrid => _userGrid;
  List<int>? get selectedCell => _selectedCell;
  int get timeRemaining => _timeRemaining;

  bool get isIdle => _status == GameStatus.idle;
  bool get isPlaying => _status == GameStatus.playing;
  bool get isPaused => _status == GameStatus.paused;

  /// Returns true if [row][col] is a clue cell (pre-filled, not editable).
  bool isClueCell(int row, int col) =>
      _puzzle.isNotEmpty && _puzzle[row][col] != 0;

  /// Returns true if the user's entry at [row][col] conflicts with the solution.
  bool hasError(int row, int col) {
    if (_userGrid.isEmpty) return false;
    final val = _userGrid[row][col];
    if (val == 0) return false;
    return val != _solution[row][col];
  }

  // ── Game lifecycle ─────────────────────────────────────────────────────────
  void startLevel(int level) {
    _timer?.cancel();
    _config = SudokuLevelManager.configForLevel(level);
    _selectedCell = null;

    final result = SudokuGenerator(clueCount: _config!.clueCount).generate();

    _puzzle = result.puzzle;
    _solution = result.solution;
    _userGrid = result.puzzle.map((row) => List<int>.from(row)).toList();

    _timeRemaining = _config!.timeLimit;
    _status = GameStatus.playing;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_status != GameStatus.playing) return;
      _timeRemaining--;
      if (_timeRemaining <= 0) {
        _timeRemaining = 0;
        _status = GameStatus.lost;
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  void pause() {
    if (_status == GameStatus.playing) {
      _timer?.cancel();
      _status = GameStatus.paused;
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Input handling ─────────────────────────────────────────────────────────
  void selectCell(int row, int col) {
    if (_status != GameStatus.playing) return;
    _selectedCell = [row, col];
    notifyListeners();
  }

  void enterDigit(int digit) {
    if (_status != GameStatus.playing) return;
    if (_selectedCell == null) return;
    final row = _selectedCell![0];
    final col = _selectedCell![1];
    if (isClueCell(row, col)) return; // cannot overwrite a clue

    _userGrid[row][col] = digit;

    // Check win
    if (SudokuGenerator.isSolved(_userGrid, _solution)) {
      _status = GameStatus.won;
      _timer?.cancel();
      HapticFeedback.heavyImpact();
    }
    notifyListeners();
  }

  void clearCell() {
    if (_status != GameStatus.playing) return;
    if (_selectedCell == null) return;
    final row = _selectedCell![0];
    final col = _selectedCell![1];
    if (isClueCell(row, col)) return;
    _userGrid[row][col] = 0;
    notifyListeners();
  }

  /// Called after level complete / game over screen is dismissed.
  void reset() {
    _timer?.cancel();
    _status = GameStatus.idle;
    _puzzle = [];
    _solution = [];
    _userGrid = [];
    _selectedCell = null;
    _timeRemaining = 0;
    notifyListeners();
  }
}
