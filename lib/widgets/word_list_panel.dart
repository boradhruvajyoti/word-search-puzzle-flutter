// Widgets: WordListPanel — scrollable list of words with strikethrough on found
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/word_entry.dart';
import '../utils/constants.dart';

class WordListPanel extends StatelessWidget {
  const WordListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final words = game.words;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1B2E) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Words  ${game.foundCount}/${words.length}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isDark
                    ? const Color(0xFF8B84FF)
                    : const Color(0xFF6C63FF),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: words.map((entry) => _WordChip(entry: entry, isDark: isDark)).toList(),
          ),
        ],
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  final WordEntry entry;
  final bool isDark;

  const _WordChip({required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = AppConstants.wordColors[
        (entry.colorIndex ?? 0) % AppConstants.wordColors.length];

    return AnimatedContainer(
      duration: AppConstants.foundWordAnimDuration,
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: entry.isFound
            ? color.withValues(alpha: 0.15)
            : (isDark
                ? const Color(0xFF242540)
                : const Color(0xFFF0F2FF)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: entry.isFound ? color : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Text(
        entry.word,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: entry.isFound
              ? color
              : (isDark
                  ? const Color(0xFFE8E9FF)
                  : const Color(0xFF1A1B2E)),
          decoration: entry.isFound ? TextDecoration.lineThrough : null,
          decorationColor: color,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
