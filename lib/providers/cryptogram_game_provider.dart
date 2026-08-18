// Providers: CryptogramGameProvider — game state, timer, guesses, and win/loss validation for Cryptograms
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../logic/cryptogram_generator.dart';
import '../logic/cryptogram_level_manager.dart';
import '../models/cryptogram_level_config.dart';
import '../models/game_state.dart';

class CryptogramGameProvider extends ChangeNotifier {
  int _level = 1;
  CryptogramLevelConfig? _config;
  CryptogramPuzzle? _puzzle;
  GameStatus _status = GameStatus.idle;
  Timer? _timer;
  int _timeRemaining = 0;

  int _selectedIndex = -1;
  final Map<String, String> _userGuesses = {}; // cipherLetter (A-Z) -> guessedLetter (A-Z)
  final Set<String> _revealedPlainLetters = {}; // plain letters that cannot be modified

  // ── Getters ────────────────────────────────────────────────────────────────
  int get level => _level;
  CryptogramLevelConfig? get config => _config;
  CryptogramPuzzle? get puzzle => _puzzle;
  GameStatus get status => _status;
  int get timeRemaining => _timeRemaining;
  int get selectedIndex => _selectedIndex;
  Map<String, String> get userGuesses => Map.unmodifiable(_userGuesses);
  Set<String> get revealedPlainLetters => Set.unmodifiable(_revealedPlainLetters);

  String? get selectedCipherLetter {
    if (_puzzle == null || _selectedIndex < 0 || _selectedIndex >= _puzzle!.cipherText.length) {
      return null;
    }
    final char = _puzzle!.cipherText[_selectedIndex];
    if (RegExp(r'[A-Z]').hasMatch(char)) {
      return char;
    }
    return null;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  void startLevel(int level) {
    _timer?.cancel();
    _level = level;
    _config = CryptogramLevelManager.configForLevel(level);

    _puzzle = CryptogramGenerator.generate(
      rawQuote: _config!.quote,
      author: _config!.author,
      category: _config!.category,
      level: level,
      initialHints: _config!.initialHints,
    );

    _userGuesses.clear();
    _revealedPlainLetters.clear();

    // Populate initial hints
    for (final plain in _puzzle!.initialRevealed) {
      _revealedPlainLetters.add(plain);
      final cipher = _puzzle!.plainToCipher[plain];
      if (cipher != null) {
        _userGuesses[cipher] = plain;
      }
    }

    _timeRemaining = _config!.timeLimit;
    _status = GameStatus.playing;

    // Find first unrevealed letter index to select
    _selectedIndex = _findFirstUnrevealedIndex();

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

  int _findFirstUnrevealedIndex() {
    if (_puzzle == null) return -1;
    final upper = _puzzle!.quote.toUpperCase();
    for (int i = 0; i < upper.length; i++) {
      final char = upper[i];
      if (RegExp(r'[A-Z]').hasMatch(char)) {
        if (!_revealedPlainLetters.contains(char)) {
          return i;
        }
      }
    }
    return 0;
  }

  void selectIndex(int index) {
    if (_puzzle == null || index < 0 || index >= _puzzle!.quote.length) return;
    final char = _puzzle!.quote.toUpperCase()[index];
    if (RegExp(r'[A-Z]').hasMatch(char)) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void inputLetter(String letter) {
    if (_status != GameStatus.playing || _puzzle == null) return;
    final upperLetter = letter.toUpperCase();
    if (!RegExp(r'[A-Z]').hasMatch(upperLetter)) return;

    final cipher = selectedCipherLetter;
    if (cipher == null) return;

    final correctPlain = _puzzle!.cipherToPlain[cipher];
    if (correctPlain != null && _revealedPlainLetters.contains(correctPlain)) {
      // Cannot overwrite locked revealed hint letters
      return;
    }

    // Set guess for all instances of this cipher letter
    _userGuesses[cipher] = upperLetter;

    // Check if puzzle is solved!
    if (_checkWin()) {
      _status = GameStatus.won;
      _timer?.cancel();
      notifyListeners();
      return;
    }

    // Advance selected index to the next unsolved/empty letter
    _advanceSelection();
    notifyListeners();
  }

  void deleteCurrentGuess() {
    if (_status != GameStatus.playing || _puzzle == null) return;
    final cipher = selectedCipherLetter;
    if (cipher == null) return;

    final correctPlain = _puzzle!.cipherToPlain[cipher];
    if (correctPlain != null && _revealedPlainLetters.contains(correctPlain)) {
      return;
    }

    _userGuesses.remove(cipher);
    notifyListeners();
  }

  bool useHint() {
    if (_status != GameStatus.playing || _puzzle == null) return false;

    // Collect all unrevealed letters present in quote
    final upper = _puzzle!.quote.toUpperCase();
    final unrevealed = <String>{};
    for (int i = 0; i < upper.length; i++) {
      final char = upper[i];
      if (RegExp(r'[A-Z]').hasMatch(char)) {
        if (!_revealedPlainLetters.contains(char)) {
          unrevealed.add(char);
        }
      }
    }

    if (unrevealed.isEmpty) return false;

    final random = Random();
    final chosenPlain = unrevealed.toList()[random.nextInt(unrevealed.length)];
    _revealedPlainLetters.add(chosenPlain);

    final cipher = _puzzle!.plainToCipher[chosenPlain];
    if (cipher != null) {
      _userGuesses[cipher] = chosenPlain;
    }

    if (_checkWin()) {
      _status = GameStatus.won;
      _timer?.cancel();
    } else {
      _advanceSelection();
    }

    notifyListeners();
    return true;
  }

  void _advanceSelection() {
    if (_puzzle == null) return;
    final upper = _puzzle!.quote.toUpperCase();
    final len = upper.length;

    // Search forward from next index
    for (int i = _selectedIndex + 1; i < len; i++) {
      final char = upper[i];
      if (RegExp(r'[A-Z]').hasMatch(char)) {
        final cipher = _puzzle!.cipherText[i];
        if (!_userGuesses.containsKey(cipher)) {
          _selectedIndex = i;
          return;
        }
      }
    }
    // Loop back around from start
    for (int i = 0; i < _selectedIndex; i++) {
      final char = upper[i];
      if (RegExp(r'[A-Z]').hasMatch(char)) {
        final cipher = _puzzle!.cipherText[i];
        if (!_userGuesses.containsKey(cipher)) {
          _selectedIndex = i;
          return;
        }
      }
    }
  }

  bool _checkWin() {
    if (_puzzle == null) return false;
    final upper = _puzzle!.quote.toUpperCase();
    for (int i = 0; i < upper.length; i++) {
      final char = upper[i];
      if (RegExp(r'[A-Z]').hasMatch(char)) {
        final cipher = _puzzle!.cipherText[i];
        final guess = _userGuesses[cipher];
        if (guess == null || guess != char) {
          return false;
        }
      }
    }
    return true;
  }

  /// Whether [letter] is already assigned as a guess to some cipher letter.
  bool isLetterUsed(String letter) {
    return _userGuesses.values.contains(letter.toUpperCase());
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
    _puzzle = null;
    _config = null;
    _userGuesses.clear();
    _revealedPlainLetters.clear();
    _selectedIndex = -1;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
