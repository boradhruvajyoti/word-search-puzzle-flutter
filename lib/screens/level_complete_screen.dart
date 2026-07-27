// Screens: LevelCompleteScreen — shows stars rewarded, word meanings educational section, next level
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/level_manager.dart';
import '../logic/word_dictionary.dart';
import '../providers/game_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/star_rating.dart';
import '../utils/extensions.dart';
import 'game_screen.dart';

class LevelCompleteScreen extends StatefulWidget {
  final int level;
  final int timeRemaining;
  final List<String> completedWords;

  const LevelCompleteScreen({
    super.key,
    required this.level,
    required this.timeRemaining,
    this.completedWords = const [],
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeSlideFade;
  late Animation<Offset> _slideAnim;
  String? _selectedWord;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeSlideFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    // Auto-select first word for immediate educational value
    if (widget.completedWords.isNotEmpty) {
      _selectedWord = widget.completedWords.first;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = LevelManager.configForLevel(widget.level);
    final stars = LevelManager.starsEarned(widget.timeRemaining, config.timeLimit);
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextLevel = widget.level + 1;
    final starsRewarded = widget.timeRemaining;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeSlideFade,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Trophy
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFBE0B), Color(0xFFFF9E00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFBE0B).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.emoji_events_rounded,
                        color: Colors.white, size: 52),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Level ${widget.level} Complete!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? const Color(0xFFE8E9FF)
                          : const Color(0xFF1A1B2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  StarRating(stars: stars),
                  const SizedBox(height: 16),
                  // Rewarded Stars Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBE0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFFFFBE0B), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFBE0B), size: 24),
                        const SizedBox(width: 6),
                        Text(
                          '+$starsRewarded Stars Earned!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFBE0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Info Chips (Time Left & Total Stars)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        label: 'Time Left',
                        value: widget.timeRemaining.toTimerString(),
                        icon: Icons.timer_rounded,
                        isDark: isDark,
                      ),
                      _InfoChip(
                        label: 'Total Stars',
                        value: '${progress.totalStars}',
                        icon: Icons.stars_rounded,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Educational Word Meaning Section ───────────────────────
                  if (widget.completedWords.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A1B2E)
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF242540)
                              : const Color(0xFFE8EAFF),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_rounded,
                                  color: Color(0xFFFFBE0B), size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'Word Meanings',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? const Color(0xFFE8E9FF)
                                      : const Color(0xFF1A1B2E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap any word below to learn its definition:',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF8B84FF)
                                  : const Color(0xFF6C63FF),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Word Chips Wrap
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.completedWords.map((word) {
                              final isSelected = _selectedWord == word;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedWord = word;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                            ? const Color(0xFF8B84FF)
                                                .withValues(alpha: 0.3)
                                            : const Color(0xFF6C63FF)
                                                .withValues(alpha: 0.15))
                                        : (isDark
                                            ? const Color(0xFF242540)
                                            : const Color(0xFFF0F2FF)),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? (isDark
                                              ? const Color(0xFF8B84FF)
                                              : const Color(0xFF6C63FF))
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        word,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                          color: isSelected
                                              ? (isDark
                                                  ? const Color(0xFF8B84FF)
                                                  : const Color(0xFF6C63FF))
                                              : (isDark
                                                  ? const Color(0xFFE8E9FF)
                                                  : const Color(0xFF1A1B2E)),
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.menu_book_rounded,
                                          size: 14,
                                          color: isDark
                                              ? const Color(0xFF8B84FF)
                                              : const Color(0xFF6C63FF),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                          // Definition Display Card
                          if (_selectedWord != null)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF242540)
                                    : const Color(0xFFF8F9FF),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF323356)
                                      : const Color(0xFFE0E3F5),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _selectedWord!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: isDark
                                              ? const Color(0xFF00E5BE)
                                              : const Color(0xFF00C9A7),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: (isDark
                                                  ? const Color(0xFF8B84FF)
                                                  : const Color(0xFF6C63FF))
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          LevelManager.categoryDisplay(
                                              widget.level),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: isDark
                                                ? const Color(0xFF8B84FF)
                                                : const Color(0xFF6C63FF),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    WordDictionary.getDefinition(
                                        _selectedWord!, config.category),
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: isDark
                                          ? const Color(0xFFE8E9FF)
                                          : const Color(0xFF333448),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  // Next level button
                  _GradientButton(
                    label: 'Next Level',
                    icon: Icons.arrow_forward_rounded,
                    onTap: () {
                      context.read<GameProvider>().reset();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => GameScreen(level: nextLevel)),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      context.read<GameProvider>().reset();
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF8B84FF)
                            : const Color(0xFF6C63FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242540) : const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF6C63FF), size: 18),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color:
                  isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? const Color(0xFFE8E9FF)
                  : const Color(0xFF1A1B2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF00C9A7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(width: 10),
            Icon(icon, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
