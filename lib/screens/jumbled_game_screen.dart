// Screens: JumbledGameScreen — gameplay view for Jumbled Words mode
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/ad_helper.dart';
import '../models/game_state.dart';
import '../providers/jumbled_game_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/extensions.dart';
import 'jumbled_game_over_screen.dart';
import 'jumbled_level_complete_screen.dart';

class JumbledGameScreen extends StatefulWidget {
  final int level;

  const JumbledGameScreen({super.key, required this.level});

  @override
  State<JumbledGameScreen> createState() => _JumbledGameScreenState();
}

class _JumbledGameScreenState extends State<JumbledGameScreen> {
  bool _initialized = false;
  bool _navigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final lang = context.read<ProgressProvider>().languageCode;
        context.read<JumbledGameProvider>().startLevel(widget.level, lang);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<JumbledGameProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Navigate on win/loss status change
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
        title: Text(
          'Jumbled Level ${widget.level}',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Timer bar
              _JumbledTimerBar(
                timeRemaining: game.timeRemaining,
                timeLimit: game.config?.timeLimit ?? 60,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              // Stars Info Bar
              _JumbledStarInfoBar(
                timeRemaining: game.timeRemaining,
                timeLimit: game.config?.timeLimit ?? 60,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              if (game.status == GameStatus.paused)
                _PauseOverlay(onResume: game.resume)
              else if (game.config == null || game.scrambledLetters.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                // Word count progress chips (e.g. Word 1 of 3)
                _WordProgressHeader(
                  current: game.currentWordIndex + 1,
                  total: game.targetWords.length,
                  isDark: isDark,
                ),
                const Spacer(),

                // Target Word Slots Display
                _TargetWordSlots(
                  placedChars: game.userPlacedChars,
                  targetChars: game.activeTargetChars,
                  onRemoveChar: game.removePlacedChar,
                  isDark: isDark,
                ),

                const Spacer(),

                // Available Scrambled Letter Tiles Grid
                _ScrambledLetterTiles(
                  scrambledLetters: game.scrambledLetters,
                  usedTileIndices: game.usedTileIndices,
                  onTapTile: game.tapTile,
                  isDark: isDark,
                ),

                const Spacer(),

                // Gameplay Action Controls (Clear, Shuffle, Hint)
                _GameplayActionBar(
                  onClear: game.clearAll,
                  onShuffle: game.shuffleLetters,
                  onHint: () {
                    AdHelper.showRewardedAd(
                      onRewardGranted: () {
                        game.useHint();
                      },
                      onAdClosed: () {},
                    );
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleWin(BuildContext context, JumbledGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeRemaining = game.timeRemaining;
    final level = widget.level;
    context
        .read<ProgressProvider>()
        .completeJumbledLevel(level, timeRemaining);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JumbledLevelCompleteScreen(
          level: level,
          timeRemaining: timeRemaining,
        ),
      ),
    );
  }

  void _handleLoss(BuildContext context, JumbledGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeLimit = game.config?.timeLimit ?? 0;
    context
        .read<ProgressProvider>()
        .failJumbledLevel(widget.level, timeLimit);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JumbledGameOverScreen(
          level: widget.level,
          timeLimit: timeLimit,
        ),
      ),
    );
  }
}

class _WordProgressHeader extends StatelessWidget {
  final int current;
  final int total;
  final bool isDark;

  const _WordProgressHeader({
    required this.current,
    required this.total,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1B2E)
            : const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Word $current of $total',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
        ),
      ),
    );
  }
}

class _TargetWordSlots extends StatelessWidget {
  final List<String?> placedChars;
  final List<String> targetChars;
  final Function(int) onRemoveChar;
  final bool isDark;

  const _TargetWordSlots({
    required this.placedChars,
    required this.targetChars,
    required this.onRemoveChar,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 10,
      children: List.generate(targetChars.length, (index) {
        final char = index < placedChars.length ? placedChars[index] : null;
        final isFilled = char != null;

        return GestureDetector(
          onTap: () => onRemoveChar(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 56,
            decoration: BoxDecoration(
              color: isFilled
                  ? (isDark ? const Color(0xFF00C9A7) : const Color(0xFF00C9A7))
                  : (isDark ? const Color(0xFF1A1B2E) : const Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isFilled
                    ? const Color(0xFF00C9A7)
                    : (isDark
                        ? const Color(0xFF33355A)
                        : const Color(0xFFCBD5E1)),
                width: 2,
              ),
              boxShadow: isFilled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00C9A7).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                char ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isFilled
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ScrambledLetterTiles extends StatelessWidget {
  final List<String> scrambledLetters;
  final Set<int> usedTileIndices;
  final Function(int) onTapTile;
  final bool isDark;

  const _ScrambledLetterTiles({
    required this.scrambledLetters,
    required this.usedTileIndices,
    required this.onTapTile,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 12,
      children: List.generate(scrambledLetters.length, (index) {
        final char = scrambledLetters[index];
        final isUsed = usedTileIndices.contains(index);

        return GestureDetector(
          onTap: isUsed ? null : () => onTapTile(index),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isUsed ? 0.35 : 1.0,
            child: Container(
              width: 52,
              height: 56,
              decoration: BoxDecoration(
                gradient: isUsed
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF8338EC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: isUsed
                    ? (isDark ? const Color(0xFF242540) : const Color(0xFFE2E8F0))
                    : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isUsed
                    ? []
                    : [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  char,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _GameplayActionBar extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onShuffle;
  final VoidCallback onHint;
  final bool isDark;

  const _GameplayActionBar({
    required this.onClear,
    required this.onShuffle,
    required this.onHint,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          label: 'Clear',
          icon: Icons.backspace_rounded,
          color: const Color(0xFFFF6B6B),
          onTap: onClear,
          isDark: isDark,
        ),
        _ActionButton(
          label: 'Shuffle',
          icon: Icons.shuffle_rounded,
          color: const Color(0xFF3A86FF),
          onTap: onShuffle,
          isDark: isDark,
        ),
        _ActionButton(
          label: 'Hint (Ad)',
          icon: Icons.lightbulb_rounded,
          color: const Color(0xFFFFBE0B),
          onTap: onHint,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionButton({
    required this.label,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JumbledTimerBar extends StatelessWidget {
  final int timeRemaining;
  final int timeLimit;
  final bool isDark;

  const _JumbledTimerBar({
    required this.timeRemaining,
    required this.timeLimit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (timeRemaining / timeLimit).clamp(0.0, 1.0);
    final isLow = timeRemaining <= 15;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1B2E) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_rounded,
            color: isLow ? const Color(0xFFFF6B6B) : const Color(0xFF00C9A7),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: isDark
                    ? const Color(0xFF242540)
                    : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLow ? const Color(0xFFFF6B6B) : const Color(0xFF00C9A7),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            timeRemaining.toTimerString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isLow
                  ? const Color(0xFFFF6B6B)
                  : (isDark ? const Color(0xFFE8E9FF) : const Color(0xFF1A1B2E)),
            ),
          ),
        ],
      ),
    );
  }
}

class _JumbledStarInfoBar extends StatelessWidget {
  final int timeRemaining;
  final int timeLimit;
  final bool isDark;

  const _JumbledStarInfoBar({
    required this.timeRemaining,
    required this.timeLimit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: Color(0xFFFFBE0B), size: 18),
              const SizedBox(width: 4),
              Text(
                '${progress.jumbledTotalStars}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? const Color(0xFFE8E9FF) : const Color(0xFF1A1B2E),
                ),
              ),
            ],
          ),
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
                size: 80, color: Color(0xFF00C9A7)),
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
            ),
          ],
        ),
      ),
    );
  }
}
