// Screens: CryptogramGameScreen — interactive Cryptogram puzzle gameplay view with on-screen keyboard
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../providers/cryptogram_game_provider.dart';
import '../providers/progress_provider.dart';
import 'cryptogram_game_over_screen.dart';
import 'cryptogram_level_complete_screen.dart';

class CryptogramGameScreen extends StatefulWidget {
  final int level;

  const CryptogramGameScreen({super.key, required this.level});

  @override
  State<CryptogramGameScreen> createState() => _CryptogramGameScreenState();
}

class _CryptogramGameScreenState extends State<CryptogramGameScreen> {
  bool _initialized = false;
  bool _navigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CryptogramGameProvider>().startLevel(widget.level);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<CryptogramGameProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Handle win / loss status changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (game.status == GameStatus.won) {
        _handleWin(context, game);
      } else if (game.status == GameStatus.lost) {
        _handleLoss(context, game);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            game.reset();
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            Text(
              'Cryptogram Level ${widget.level}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            if (game.config != null)
              Text(
                '${game.config!.difficulty} • ${game.config!.category}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFC77DFF) : const Color(0xFF7209B7),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              game.status == GameStatus.paused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
              size: 28,
            ),
            onPressed: () {
              if (game.status == GameStatus.paused) {
                game.resume();
              } else {
                game.pause();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 6),
              // Timer bar
              _CryptogramTimerBar(
                timeRemaining: game.timeRemaining,
                totalTime: game.config?.timeLimit ?? 180,
                isPaused: game.status == GameStatus.paused,
              ),
              const SizedBox(height: 6),
              // Star reward & penalty info bar
              _CryptogramStarInfoBar(
                timeRemaining: game.timeRemaining,
                timeLimit: game.config?.timeLimit ?? 180,
              ),
              const SizedBox(height: 10),
              // Main puzzle board or Pause overlay
              if (game.status == GameStatus.paused)
                _PauseOverlay(onResume: game.resume)
              else if (game.puzzle == null)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                // Scrollable Quote Grid
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _CryptogramBoard(game: game, isDark: isDark),
                  ),
                ),
                // Author credit chip
                if (game.config != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '— ${game.config!.author}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ),
                // On-screen custom QWERTY keyboard
                _CryptogramKeyboard(game: game, isDark: isDark),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleWin(BuildContext context, CryptogramGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeRemaining = game.timeRemaining;
    final level = widget.level;
    final quote = game.config?.quote ?? '';
    final author = game.config?.author ?? '';

    context.read<ProgressProvider>().completeCryptogramLevel(level, timeRemaining);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CryptogramLevelCompleteScreen(
          level: level,
          timeRemaining: timeRemaining,
          quote: quote,
          author: author,
        ),
      ),
    );
  }

  void _handleLoss(BuildContext context, CryptogramGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeLimit = game.config?.timeLimit ?? 0;

    context.read<ProgressProvider>().failCryptogramLevel(widget.level, timeLimit);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CryptogramGameOverScreen(
          level: widget.level,
          timeLimit: timeLimit,
        ),
      ),
    );
  }
}

// ── Cryptogram Puzzle Board ──────────────────────────────────────────────────

class _CryptogramBoard extends StatelessWidget {
  final CryptogramGameProvider game;
  final bool isDark;

  const _CryptogramBoard({required this.game, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final puzzle = game.puzzle!;
    final quote = puzzle.quote;
    final cipher = puzzle.cipherText;
    final selectedCipher = game.selectedCipherLetter;

    // Split text into words while keeping indices accurate
    final words = _splitIntoWords(quote, cipher);

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: words.map((word) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: word.entries.map((entry) {
            final index = entry.index;
            final isLetter = RegExp(r'[A-Z]').hasMatch(entry.plainChar.toUpperCase());

            if (!isLetter) {
              // Punctuation / Space
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                child: Text(
                  entry.plainChar,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              );
            }

            final cipherChar = entry.cipherChar;
            final isSelected = index == game.selectedIndex;
            final isMatchingCipher = selectedCipher != null && cipherChar == selectedCipher;
            final isRevealed = game.revealedPlainLetters.contains(entry.plainChar.toUpperCase());
            final guess = game.userGuesses[cipherChar];

            const primaryColor = Color(0xFF8338EC);
            const accentColor = Color(0xFFFF006E);

            return GestureDetector(
              onTap: () => game.selectIndex(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 32,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withValues(alpha: isDark ? 0.35 : 0.2)
                      : (isMatchingCipher
                          ? accentColor.withValues(alpha: isDark ? 0.2 : 0.12)
                          : (isDark ? const Color(0xFF1E1F35) : const Color(0xFFF0F2FF))),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : (isMatchingCipher
                            ? accentColor
                            : (isDark ? const Color(0xFF323455) : const Color(0xFFD6DBF5))),
                    width: isSelected ? 2.0 : (isMatchingCipher ? 1.5 : 1.0),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Guessed / Revealed Letter
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          guess ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isRevealed
                                ? const Color(0xFF06D6A0)
                                : (isSelected
                                    ? primaryColor
                                    : (isDark ? Colors.white : const Color(0xFF1A1B2E))),
                          ),
                        ),
                      ),
                    ),
                    // Divider
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                    // Cipher Code Letter
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          cipherChar,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  List<_WordGroup> _splitIntoWords(String quote, String cipher) {
    final groups = <_WordGroup>[];
    _WordGroup current = _WordGroup();

    for (int i = 0; i < quote.length; i++) {
      final pChar = quote[i];
      final cChar = cipher[i];

      if (pChar == ' ') {
        if (current.entries.isNotEmpty) {
          groups.add(current);
          current = _WordGroup();
        }
      } else {
        current.entries.add(_CharEntry(index: i, plainChar: pChar, cipherChar: cChar));
      }
    }
    if (current.entries.isNotEmpty) {
      groups.add(current);
    }
    return groups;
  }
}

class _CharEntry {
  final int index;
  final String plainChar;
  final String cipherChar;

  _CharEntry({required this.index, required this.plainChar, required this.cipherChar});
}

class _WordGroup {
  final List<_CharEntry> entries = [];
}

// ── On-Screen Keyboard ────────────────────────────────────────────────────────

class _CryptogramKeyboard extends StatelessWidget {
  final CryptogramGameProvider game;
  final bool isDark;

  const _CryptogramKeyboard({required this.game, required this.isDark});

  static const List<List<String>> _layout = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141526) : const Color(0xFFE8EAFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1
          _buildRow(_layout[0]),
          const SizedBox(height: 4),
          // Row 2
          _buildRow(_layout[1]),
          const SizedBox(height: 4),
          // Row 3 with Hint, Keys, Backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hint button
              _SpecialKey(
                icon: Icons.lightbulb_rounded,
                color: const Color(0xFFFFBE0B),
                onTap: game.useHint,
                isDark: isDark,
              ),
              const SizedBox(width: 4),
              ..._layout[2].map((letter) => _buildKey(letter)),
              const SizedBox(width: 4),
              // Delete button
              _SpecialKey(
                icon: Icons.backspace_rounded,
                color: const Color(0xFFFF6B6B),
                onTap: game.deleteCurrentGuess,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((k) => _buildKey(k)).toList(),
    );
  }

  Widget _buildKey(String letter) {
    final isUsed = game.isLetterUsed(letter);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GestureDetector(
          onTap: () => game.inputLetter(letter),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isUsed
                  ? (isDark ? const Color(0xFF252640) : const Color(0xFFCFD4F5))
                  : (isDark ? const Color(0xFF2A2C4A) : Colors.white),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isUsed
                      ? (isDark ? Colors.white38 : Colors.black38)
                      : (isDark ? Colors.white : const Color(0xFF1A1B2E)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecialKey extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _SpecialKey({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.2 : 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

// ── HUD Elements ─────────────────────────────────────────────────────────────

class _CryptogramTimerBar extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;
  final bool isPaused;

  const _CryptogramTimerBar({
    required this.timeRemaining,
    required this.totalTime,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalTime > 0 ? (timeRemaining / totalTime).clamp(0.0, 1.0) : 0.0;
    final isLow = timeRemaining <= 20;

    final barColor = isLow
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF8338EC);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timer_rounded,
                  color: barColor,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${timeRemaining}s',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: barColor,
                  ),
                ),
              ],
            ),
            Text(
              isPaused ? 'Paused' : 'Time Remaining',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: barColor.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(barColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _CryptogramStarInfoBar extends StatelessWidget {
  final int timeRemaining;
  final int timeLimit;

  const _CryptogramStarInfoBar({
    required this.timeRemaining,
    required this.timeLimit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1B2E) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Win Reward
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFF06D6A0), size: 18),
              const SizedBox(width: 4),
              Text(
                '+$timeRemaining',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF06D6A0),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                'on win',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
          // Total Stars
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: Color(0xFFFFBE0B), size: 18),
              const SizedBox(width: 4),
              Text(
                '${progress.totalStars}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? const Color(0xFFE8E9FF) : const Color(0xFF1A1B2E),
                ),
              ),
            ],
          ),
          // Fail Penalty
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'on loss',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                '-$timeLimit',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star_half_rounded, color: Color(0xFFFF6B6B), size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;

  const _PauseOverlay({required this.onResume});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pause_circle_filled_rounded,
                size: 80, color: Color(0xFF8338EC)),
            const SizedBox(height: 20),
            const Text(
              'Paused',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Resume'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8338EC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
