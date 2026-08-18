// Screens: QuadsumGameScreen — interactive 3x3 Quadsum puzzle gameplay with keypad, keyboard navigation & number tray
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../providers/progress_provider.dart';
import '../providers/quadsum_game_provider.dart';
import '../widgets/quadsum_grid.dart';
import 'quadsum_game_over_screen.dart';
import 'quadsum_level_complete_screen.dart';

class QuadsumGameScreen extends StatefulWidget {
  final int level;

  const QuadsumGameScreen({super.key, required this.level});

  @override
  State<QuadsumGameScreen> createState() => _QuadsumGameScreenState();
}

class _QuadsumGameScreenState extends State<QuadsumGameScreen> {
  final FocusNode _focusNode = FocusNode();
  bool _initialized = false;
  bool _navigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<QuadsumGameProvider>().startLevel(widget.level);
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event, QuadsumGameProvider game) {
    if (event is! KeyDownEvent) return;

    final key = event.logicalKey;

    // Digits 1-9
    if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
      game.inputDigit(1);
    } else if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) {
      game.inputDigit(2);
    } else if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) {
      game.inputDigit(3);
    } else if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) {
      game.inputDigit(4);
    } else if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) {
      game.inputDigit(5);
    } else if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) {
      game.inputDigit(6);
    } else if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) {
      game.inputDigit(7);
    } else if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) {
      game.inputDigit(8);
    } else if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) {
      game.inputDigit(9);
    } else if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
      game.eraseSelected();
    } else if (key == LogicalKeyboardKey.arrowUp) {
      game.moveSelection(-1, 0);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      game.moveSelection(1, 0);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      game.moveSelection(0, -1);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      game.moveSelection(0, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<QuadsumGameProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Handle win / loss
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (game.status == GameStatus.won) {
        _handleWin(context, game);
      } else if (game.status == GameStatus.lost) {
        _handleLoss(context, game);
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final gridDimension = (screenWidth - 48).clamp(240.0, 320.0);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) => _handleKeyEvent(event, game),
      child: Scaffold(
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
                'Quadsum Level ${widget.level}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              if (game.config != null)
                Text(
                  '${game.config!.difficulty} • Place Digits 1–9',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 6),
                // Timer bar
                _QuadsumTimerBar(
                  timeRemaining: game.timeRemaining,
                  totalTime: game.config?.timeLimit ?? 180,
                  isPaused: game.status == GameStatus.paused,
                ),
                const SizedBox(height: 6),
                // Star reward & penalty info bar
                _QuadsumStarInfoBar(
                  timeRemaining: game.timeRemaining,
                  timeLimit: game.config?.timeLimit ?? 180,
                ),
                const SizedBox(height: 10),

                // Main Board or Pause Overlay
                if (game.status == GameStatus.paused)
                  _PauseOverlay(onResume: game.resume)
                else ...[
                  // Grid
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QuadsumGrid(size: gridDimension),
                            const SizedBox(height: 16),
                            // Used Numbers Tray
                            _UsedNumbersTray(game: game, isDark: isDark),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Keypad & Action Controls
                  _QuadsumKeypad(game: game, isDark: isDark),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleWin(BuildContext context, QuadsumGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeRemaining = game.timeRemaining;
    final moves = game.movesCount;
    final errors = game.errorCount;
    final level = widget.level;

    context.read<ProgressProvider>().completeQuadsumLevel(level, timeRemaining);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuadsumLevelCompleteScreen(
          level: level,
          timeRemaining: timeRemaining,
          moves: moves,
          errors: errors,
        ),
      ),
    );
  }

  void _handleLoss(BuildContext context, QuadsumGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeLimit = game.config?.timeLimit ?? 0;

    context.read<ProgressProvider>().failQuadsumLevel(widget.level, timeLimit);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuadsumGameOverScreen(
          level: widget.level,
          timeLimit: timeLimit,
        ),
      ),
    );
  }
}

// ── Used Numbers Tray ────────────────────────────────────────────────────────

class _UsedNumbersTray extends StatelessWidget {
  final QuadsumGameProvider game;
  final bool isDark;

  const _UsedNumbersTray({required this.game, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final used = game.usedDigits;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141526) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(9, (index) {
          final digit = index + 1;
          final isUsed = used.contains(digit);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isUsed
                    ? const Color(0xFF06D6A0).withValues(alpha: isDark ? 0.25 : 0.18)
                    : (isDark ? const Color(0xFF262847) : Colors.white),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUsed
                      ? const Color(0xFF06D6A0)
                      : (isDark ? Colors.white12 : Colors.black12),
                  width: isUsed ? 1.5 : 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  '$digit',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isUsed
                        ? const Color(0xFF06D6A0)
                        : (isDark ? Colors.white70 : const Color(0xFF1A1B2E)),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── On-Screen Keypad ──────────────────────────────────────────────────────────

class _QuadsumKeypad extends StatelessWidget {
  final QuadsumGameProvider game;
  final bool isDark;

  const _QuadsumKeypad({required this.game, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141526) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Digits 1 to 5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3, 4, 5].map((d) => _buildDigitKey(d)).toList(),
          ),
          const SizedBox(height: 6),
          // Row 2: Digits 6 to 9 and Erase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...[6, 7, 8, 9].map((d) => _buildDigitKey(d)),
              _buildActionKey(
                icon: Icons.backspace_rounded,
                color: const Color(0xFFFF6B6B),
                onTap: game.eraseSelected,
                label: 'Clear',
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Row 3: Actions (Undo, Restart)
          Row(
            children: [
              Expanded(
                child: _buildPillAction(
                  icon: Icons.undo_rounded,
                  label: 'Undo',
                  onTap: game.canUndo ? game.undo : null,
                  color: const Color(0xFF3A86FF),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPillAction(
                  icon: Icons.refresh_rounded,
                  label: 'Restart',
                  onTap: game.restart,
                  color: const Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDigitKey(int digit) {
    final isUsed = game.isDigitUsed(digit);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: () => game.inputDigit(digit),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isUsed
                  ? (isDark ? const Color(0xFF20233D) : const Color(0xFFE2E8F0))
                  : (isDark ? const Color(0xFF262847) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$digit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
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

  Widget _buildActionKey({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String label,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 22),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillAction({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required Color color,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: isEnabled
              ? color.withValues(alpha: isDark ? 0.2 : 0.12)
              : (isDark ? Colors.white10 : Colors.black12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? color : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isEnabled ? color : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isEnabled
                    ? (isDark ? Colors.white : color)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HUD Elements ─────────────────────────────────────────────────────────────

class _QuadsumTimerBar extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;
  final bool isPaused;

  const _QuadsumTimerBar({
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
        : const Color(0xFF00B4D8);

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

class _QuadsumStarInfoBar extends StatelessWidget {
  final int timeRemaining;
  final int timeLimit;

  const _QuadsumStarInfoBar({
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
                '${progress.quadsumStars}',
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
                size: 80, color: Color(0xFF00B4D8)),
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
                backgroundColor: const Color(0xFF00B4D8),
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
