import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/grid_widget.dart';
import '../widgets/word_list_panel.dart';
import '../widgets/timer_bar.dart';
import 'level_complete_screen.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  final int level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final lang = context.read<ProgressProvider>().languageCode;
        context.read<GameProvider>().startLevel(widget.level, lang);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

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
        title: Text(
          'Level ${widget.level}',
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
              const TimerBar(),
              const SizedBox(height: 8),
              // Star reward & penalty info bar
              const _StarInfoBar(),
              const SizedBox(height: 10),
              // Pause overlay
              if (game.status == GameStatus.paused)
                _PauseOverlay(onResume: game.resume)
              else ...[
                // Grid — takes most of the space
                Expanded(
                  child: Center(
                    child: game.grid.isEmpty
                        ? const CircularProgressIndicator()
                        : const GridWidget(),
                  ),
                ),
                const SizedBox(height: 12),
                // Word list
                const WordListPanel(),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _navigating = false;

  void _handleWin(BuildContext context, GameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeRemaining = game.timeRemaining;
    final level = widget.level;
    context
        .read<ProgressProvider>()
        .completeLevel(level, timeRemaining);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LevelCompleteScreen(
          level: level,
          timeRemaining: timeRemaining,
        ),
      ),
    );
  }

  void _handleLoss(BuildContext context, GameProvider game) {
    if (_navigating) return;
    _navigating = true;
    final timeLimit = game.config?.timeLimit ?? 0;
    context.read<ProgressProvider>().failLevel(widget.level, timeLimit);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          level: widget.level,
          timeLimit: timeLimit,
        ),
      ),
    );
  }
}

class _StarInfoBar extends StatelessWidget {
  const _StarInfoBar();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
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
              const Icon(Icons.star_rounded, color: Color(0xFF06D6A0), size: 18),
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
          // Total Stars
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: Color(0xFFFFBE0B), size: 18),
              const SizedBox(width: 4),
              Text(
                '${progress.wordSearchStars}',
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
                '-$penalty',
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
                size: 80, color: Color(0xFF6C63FF)),
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
