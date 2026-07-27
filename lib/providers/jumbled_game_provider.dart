// Providers: JumbledGameProvider — state management for Jumbled Words gameplay
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../logic/jumbled_level_manager.dart';
import '../models/game_state.dart';
import '../models/jumbled_level_config.dart';

class JumbledGameProvider extends ChangeNotifier {
  GameStatus _status = GameStatus.idle;
  JumbledLevelConfig? _config;

  // Words progress
  int _currentWordIndex = 0;
  List<String> _targetWords = [];
  Set<int> _completedWordIndices = {};

  // Current active word state
  String _activeTargetWord = '';
  List<String> _activeTargetChars = [];
  List<String> _scrambledLetters = [];
  List<String?> _userPlacedChars = [];
  Set<int> _usedTileIndices = {};

  // Timer
  int _timeRemaining = 0;
  Timer? _timer;

  // ── Getters ────────────────────────────────────────────────────────────────
  GameStatus get status => _status;
  JumbledLevelConfig? get config => _config;
  int get currentWordIndex => _currentWordIndex;
  List<String> get targetWords => _targetWords;
  Set<int> get completedWordIndices => _completedWordIndices;

  String get activeTargetWord => _activeTargetWord;
  List<String> get activeTargetChars => _activeTargetChars;
  List<String> get scrambledLetters => _scrambledLetters;
  List<String?> get userPlacedChars => _userPlacedChars;
  Set<int> get usedTileIndices => _usedTileIndices;

  int get timeRemaining => _timeRemaining;
  bool get isWordSolved =>
      _userPlacedChars.join('') == _activeTargetWord &&
      _userPlacedChars.every((c) => c != null);

  void _safeHaptic(Future<void> Function() action) {
    try {
      action();
    } catch (_) {}
  }

  // ── Game Lifecycle ─────────────────────────────────────────────────────────
  void startLevel(int level, [String languageCode = 'en']) {
    _timer?.cancel();
    _status = GameStatus.playing;
    _config = JumbledLevelManager.configForLevel(level, languageCode);
    _targetWords = List.from(_config!.targetWords);
    _completedWordIndices = {};
    _currentWordIndex = 0;

    _setupWord(_currentWordIndex);

    _timeRemaining = _config!.timeLimit;
    _startTimer();
    notifyListeners();
  }

  void _setupWord(int wordIndex) {
    if (wordIndex < 0 || wordIndex >= _targetWords.length) return;
    _currentWordIndex = wordIndex;
    _activeTargetWord = _targetWords[wordIndex];
    _activeTargetChars = JumbledLevelManager.wordToChars(_activeTargetWord);
    _scrambledLetters = JumbledLevelManager.scrambleWord(_activeTargetWord);
    _userPlacedChars = List<String?>.filled(_activeTargetChars.length, null);
    _usedTileIndices = {};
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

  // ── User Actions ───────────────────────────────────────────────────────────
  /// Tap an available scrambled letter tile at [tileIndex]
  void tapTile(int tileIndex) {
    if (_status != GameStatus.playing) return;
    if (_usedTileIndices.contains(tileIndex)) return;

    // Find first empty slot in userPlacedChars
    final emptySlot = _userPlacedChars.indexOf(null);
    if (emptySlot == -1) return;

    final char = _scrambledLetters[tileIndex];
    _userPlacedChars[emptySlot] = char;
    _usedTileIndices.add(tileIndex);
    _safeHaptic(HapticFeedback.lightImpact);

    _checkWordCompletion();
    notifyListeners();
  }

  /// Tap a placed letter slot to remove it back to scrambled pool
  void removePlacedChar(int slotIndex) {
    if (_status != GameStatus.playing) return;
    if (slotIndex < 0 || slotIndex >= _userPlacedChars.length) return;

    final charToRemove = _userPlacedChars[slotIndex];
    if (charToRemove == null) return;

    _userPlacedChars[slotIndex] = null;

    // Find matching used tile index and free it
    for (final usedIndex in _usedTileIndices.toList()) {
      if (_scrambledLetters[usedIndex] == charToRemove) {
        _usedTileIndices.remove(usedIndex);
        break;
      }
    }
    _safeHaptic(HapticFeedback.selectionClick);
    notifyListeners();
  }

  /// Clear all placed letters for active word
  void clearAll() {
    if (_status != GameStatus.playing) return;
    _userPlacedChars = List<String?>.filled(_activeTargetChars.length, null);
    _usedTileIndices = {};
    notifyListeners();
  }

  /// Shuffle remaining unused letter tiles
  void shuffleLetters() {
    if (_status != GameStatus.playing) return;
    clearAll();
    _scrambledLetters.shuffle();
    notifyListeners();
  }

  /// Provide a hint: fills the next empty or incorrect slot with correct character
  void useHint() {
    if (_status != GameStatus.playing) return;

    for (int i = 0; i < _activeTargetChars.length; i++) {
      if (_userPlacedChars[i] != _activeTargetChars[i]) {
        // If there was a wrong character placed here, remove it first
        if (_userPlacedChars[i] != null) {
          removePlacedChar(i);
        }

        final targetChar = _activeTargetChars[i];

        // Find an unused tile with this target char
        int? matchingTileIndex;
        for (int t = 0; t < _scrambledLetters.length; t++) {
          if (!_usedTileIndices.contains(t) && _scrambledLetters[t] == targetChar) {
            matchingTileIndex = t;
            break;
          }
        }

        // If none found unused (e.g. misplaced elsewhere), swap it from that slot
        if (matchingTileIndex == null) {
          for (int s = 0; s < _userPlacedChars.length; s++) {
            if (_userPlacedChars[s] == targetChar && s != i) {
              removePlacedChar(s);
              for (int t = 0; t < _scrambledLetters.length; t++) {
                if (!_usedTileIndices.contains(t) && _scrambledLetters[t] == targetChar) {
                  matchingTileIndex = t;
                  break;
                }
              }
              break;
            }
          }
        }

        if (matchingTileIndex != null) {
          _userPlacedChars[i] = targetChar;
          _usedTileIndices.add(matchingTileIndex);
          _safeHaptic(HapticFeedback.mediumImpact);
          _checkWordCompletion();
          notifyListeners();
          return;
        }
      }
    }
  }

  void _checkWordCompletion() {
    // If word is correctly formed
    if (_userPlacedChars.every((c) => c != null)) {
      final currentAttempt = _userPlacedChars.join('');
      if (currentAttempt == _activeTargetWord) {
        _completedWordIndices.add(_currentWordIndex);
        _safeHaptic(HapticFeedback.heavyImpact);

        if (_completedWordIndices.length == _targetWords.length) {
          _status = GameStatus.won;
          _timer?.cancel();
        } else {
          // Move to next word after brief delay
          Future.delayed(const Duration(milliseconds: 300), () {
            if (_status == GameStatus.playing) {
              _setupWord(_currentWordIndex + 1);
              notifyListeners();
            }
          });
        }
      }
    }
  }

  void reset() {
    _timer?.cancel();
    _status = GameStatus.idle;
    _targetWords = [];
    _completedWordIndices = {};
    _currentWordIndex = 0;
    _scrambledLetters = [];
    _userPlacedChars = [];
    _usedTileIndices = {};
    _timeRemaining = 0;
    notifyListeners();
  }
}
