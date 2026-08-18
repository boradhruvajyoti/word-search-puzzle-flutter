// Screens: SudokuGameScreen — gameplay view for Sudoku mode with digit input pad
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/sudoku_level_manager.dart';
import '../models/game_state.dart';
import '../providers/progress_provider.dart';
import '../providers/sudoku_game_provider.dart';
import 'sudoku_game_over_screen.dart';
import 'sudoku_level_complete_screen.dart';

class SudokuGameScreen extends StatefulWidget {
  final int level;

  const SudokuGameScreen({super.key, required this.level});

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  bool _initialized = false;
  bool _navigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SudokuGameProvider>().startLevel(widget.level);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SudokuGameProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Navigate on status change
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sudoku Level ${widget.level}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              SudokuLevelManager.difficultyName(widget.level),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFF8B84FF)
                    : const Color(0xFF6C63FF),
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
              const SizedBox(height: 8),
              // Timer bar (reused widget)
              const _SudokuTimerBar(),
              const SizedBox(height: 8),
              // Star reward & penalty info bar
              const _SudokuStarInfoBar(),
              const SizedBox(height: 10),
              // Pause overlay or game content
              if (game.status == GameStatus.paused)
                Expanded(child: _PauseOverlay(onResume: game.resume))
              else ...[
                // Sudoku grid
                Expanded(
                  child: Center(
                    child: game.puzzle.isEmpty
                        ? const CircularProgressIndicator()
                        : _SudokuGrid(isDark: isDark),
                  ),
                ),
                const SizedBox(height: 12),
                // Digit input pad (1-9 in 3×3)
                _DigitPad(isDark: isDark),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleWin(BuildContext context, SudokuGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeRemaining = game.timeRemaining;
    final level = widget.level;
    context.read<ProgressProvider>().completeSudokuLevel(level, timeRemaining);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SudokuLevelCompleteScreen(
          level: level,
          timeRemaining: timeRemaining,
        ),
      ),
    );
  }

  void _handleLoss(BuildContext context, SudokuGameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeLimit = game.config?.timeLimit ?? 0;
    context.read<ProgressProvider>().failSudokuLevel(widget.level, timeLimit);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SudokuGameOverScreen(
          level: widget.level,
          timeLimit: timeLimit,
        ),
      ),
    );
  }
}

// ── Sudoku Grid ──────────────────────────────────────────────────────────────

class _SudokuGrid extends StatelessWidget {
  final bool isDark;

  const _SudokuGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {


    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1B2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: 81,
            itemBuilder: (context, index) {
              final row = index ~/ 9;
              final col = index % 9;
              return _SudokuCell(row: row, col: col, isDark: isDark);
            },
          ),
        ),
      ),
    );
  }
}

class _SudokuCell extends StatelessWidget {
  final int row;
  final int col;
  final bool isDark;

  const _SudokuCell({
    required this.row,
    required this.col,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SudokuGameProvider>();
    final value = game.userGrid.isEmpty ? 0 : game.userGrid[row][col];
    final isClue = game.isClueCell(row, col);
    final isSelected = game.selectedCell != null &&
        game.selectedCell![0] == row &&
        game.selectedCell![1] == col;
    final hasError = game.hasError(row, col);

    // Thick border for 3×3 box boundaries
    final borderLeft = col % 3 == 0 ? 2.0 : 0.5;
    final borderTop = row % 3 == 0 ? 2.0 : 0.5;
    final borderRight = col == 8 ? 2.0 : 0.5;
    final borderBottom = row == 8 ? 2.0 : 0.5;
    final borderColor = isDark ? const Color(0xFF4A4B6E) : const Color(0xFFBBBBCC);
    final thickColor = isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF);

    Color bgColor;
    if (isSelected) {
      bgColor = isDark
          ? const Color(0xFF6C63FF).withValues(alpha: 0.35)
          : const Color(0xFF6C63FF).withValues(alpha: 0.12);
    } else if (hasError) {
      bgColor = isDark
          ? const Color(0xFFFF6B6B).withValues(alpha: 0.25)
          : const Color(0xFFFF6B6B).withValues(alpha: 0.1);
    } else if (isClue) {
      bgColor = isDark ? const Color(0xFF242540) : const Color(0xFFF0F2FF);
    } else {
      bgColor = isDark ? const Color(0xFF1A1B2E) : Colors.white;
    }

    return GestureDetector(
      onTap: () {
        if (!isClue) {
          game.selectCell(row, col);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            left: BorderSide(
                color: col % 3 == 0 ? thickColor : borderColor,
                width: borderLeft),
            top: BorderSide(
                color: row % 3 == 0 ? thickColor : borderColor,
                width: borderTop),
            right: BorderSide(
                color: col == 8 ? thickColor : borderColor,
                width: borderRight),
            bottom: BorderSide(
                color: row == 8 ? thickColor : borderColor,
                width: borderBottom),
          ),
        ),
        child: Center(
          child: value == 0
              ? null
              : Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        isClue ? FontWeight.w800 : FontWeight.w500,
                    color: hasError
                        ? const Color(0xFFFF6B6B)
                        : isClue
                            ? (isDark
                                ? const Color(0xFFE8E9FF)
                                : const Color(0xFF1A1B2E))
                            : const Color(0xFF6C63FF),
                  ),
                ),
        ),
      ),
    );
  }
}

// ── Digit Input Pad (1–9 in 3×3) ────────────────────────────────────────────

class _DigitPad extends StatelessWidget {
  final bool isDark;

  const _DigitPad({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SudokuGameProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 2×4 grid for digits 1–8
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.8,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            final digit = index + 1;
            return _DigitButton(
              digit: digit,
              isDark: isDark,
              onTap: () => game.enterDigit(digit),
            );
          },
        ),
        const SizedBox(height: 8),
        // Row for Digit 9 and Clear button
        SizedBox(
          height: 42,
          child: Row(
            children: [
              Expanded(
                child: _DigitButton(
                  digit: 9,
                  isDark: isDark,
                  onTap: () => game.enterDigit(9),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ClearButton(
                  isDark: isDark,
                  onTap: game.clearCell,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DigitButton extends StatelessWidget {
  final int digit;
  final bool isDark;
  final VoidCallback onTap;

  const _DigitButton({
    required this.digit,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF3A86FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$digit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _ClearButton({
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242540) : const Color(0xFFE8EAFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? const Color(0xFF4A4B6E)
                : const Color(0xFF6C63FF).withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 20,
            color: isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
          ),
        ),
      ),
    );
  }
}

// ── Timer bar wrapper ────────────────────────────────────────────────────────

class _SudokuTimerBar extends StatelessWidget {
  const _SudokuTimerBar();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SudokuGameProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeLimit = game.config?.timeLimit ?? 1;
    final timeRemaining = game.timeRemaining;
    final ratio = timeLimit > 0 ? timeRemaining / timeLimit : 0.0;
    final isWarning = timeRemaining <= 15;

    final barColor = isWarning
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF6C63FF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.timer_rounded,
                    size: 16,
                    color: isWarning
                        ? const Color(0xFFFF6B6B)
                        : (isDark
                            ? const Color(0xFF8B84FF)
                            : const Color(0xFF6C63FF))),
                const SizedBox(width: 4),
                Text(
                  _fmt(timeRemaining),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isWarning
                        ? const Color(0xFFFF6B6B)
                        : (isDark
                            ? const Color(0xFF8B84FF)
                            : const Color(0xFF6C63FF)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor:
                isDark ? const Color(0xFF242540) : const Color(0xFFE8EAFF),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  String _fmt(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

// ── Star info bar ────────────────────────────────────────────────────────────

class _SudokuStarInfoBar extends StatelessWidget {
  const _SudokuStarInfoBar();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SudokuGameProvider>();
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reward = game.timeRemaining;
    final penalty = game.config?.timeLimit ?? 0;

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
              const Icon(Icons.star_rounded,
                  color: Color(0xFF06D6A0), size: 18),
              const SizedBox(width: 4),
              Text(
                '+$reward',
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
          // Total Stars (shared across all games)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded,
                  color: Color(0xFFFFBE0B), size: 18),
              const SizedBox(width: 4),
              Text(
                '${progress.sudokuStars}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? const Color(0xFFE8E9FF)
                      : const Color(0xFF1A1B2E),
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
                '-$penalty',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star_half_rounded,
                  color: Color(0xFFFF6B6B), size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Pause overlay ────────────────────────────────────────────────────────────

class _PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;

  const _PauseOverlay({required this.onResume});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pause_circle_filled_rounded,
              size: 80, color: Color(0xFF3A86FF)),
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
    );
  }
}
