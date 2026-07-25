// Providers: GameProvider — full game state: grid, timer, swipe, found words
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../logic/grid_generator.dart';
import '../logic/level_manager.dart';
import '../logic/word_bank.dart';
import '../logic/word_validator.dart';
import '../models/game_state.dart';
import '../models/level_config.dart';
import '../models/word_entry.dart';

class GameProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  GameStatus _status = GameStatus.idle;
  LevelConfig? _config;
  List<List<String>> _grid = [];
  List<WordEntry> _words = [];

  // Swipe state
  List<List<int>> _highlightedCells = [];
  List<int>? _swipeStart;


  // Timer
  int _timeRemaining = 0;
  Timer? _timer;

  // ── Getters ────────────────────────────────────────────────────────────────
  GameStatus get status => _status;
  LevelConfig? get config => _config;
  List<List<String>> get grid => _grid;
  List<WordEntry> get words => _words;
  List<List<int>> get highlightedCells => _highlightedCells;
  int get timeRemaining => _timeRemaining;
  int get foundCount => _words.where((w) => w.isFound).length;
  bool get allFound => _words.isNotEmpty && _words.every((w) => w.isFound);

  // ── Game lifecycle ─────────────────────────────────────────────────────────
  void startLevel(int level) {
    _timer?.cancel();
    _status = GameStatus.playing;
    _config = LevelManager.configForLevel(level);
    _highlightedCells = [];
    _swipeStart = null;

    final category = _config!.category;
    final availableWords =
        WordBank.wordsForSize(_config!.gridSize, category);
    final selectedWords = availableWords.take(_config!.wordCount).toList();

    final result = GridGenerator(
      gridSize: _config!.gridSize,
      words: selectedWords,
    ).generate();

    _grid = result.grid;
    _words = result.placedWords.toList();

    _timeRemaining = _config!.timeLimit;
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

  // ── Swipe gesture handling ─────────────────────────────────────────────────
  void onSwipeStart(List<int> cell) {
    if (_status != GameStatus.playing) return;
    _swipeStart = cell;
    _highlightedCells = [cell];
    notifyListeners();
  }

  void onSwipeUpdate(List<int> cell) {
    if (_status != GameStatus.playing || _swipeStart == null) return;
    final path = WordValidator.cellsBetween(_swipeStart!, cell);
    _highlightedCells = path ?? [_swipeStart!];
    notifyListeners();
  }

  void onSwipeEnd() {
    if (_status != GameStatus.playing || _swipeStart == null) return;

    final path = _highlightedCells;
    final matched = WordValidator.validateSwipe(
      swipeCells: path,
      wordEntries: _words,
    );

    if (matched != null) {
      _markWordFound(matched);
      HapticFeedback.mediumImpact();

      if (WordValidator.isWinCondition(_words)) {
        _status = GameStatus.won;
        _timer?.cancel();
      }
    }

    _highlightedCells = [];
    _swipeStart = null;
    notifyListeners();
  }

  void _markWordFound(WordEntry entry) {
    final idx = _words.indexWhere((w) => w.word == entry.word);
    if (idx != -1) {
      _words[idx] = _words[idx].copyWith(isFound: true);
    }
  }

  /// Called after level complete screen is dismissed
  void reset() {
    _timer?.cancel();
    _status = GameStatus.idle;
    _grid = [];
    _words = [];
    _highlightedCells = [];
    _timeRemaining = 0;
    notifyListeners();
  }
}
