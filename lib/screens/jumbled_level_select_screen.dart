// Screens: JumbledLevelSelectScreen — 1,000 level selection screen for Jumbled Words
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/level_tile.dart';
import 'jumbled_game_screen.dart';

class JumbledLevelSelectScreen extends StatelessWidget {
  const JumbledLevelSelectScreen({super.key});

  static const int totalLevels = 1000;

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumbled Words Levels'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1B2E)
                    : const Color(0xFFF0F2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded,
                      color: Color(0xFF00C9A7), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    '${progress.jumbledHighestUnlockedLevel - 1} levels solved',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFFE8E9FF)
                          : const Color(0xFF1A1B2E),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFBE0B), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${progress.jumbledTotalStars} Stars',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFFE8E9FF)
                              : const Color(0xFF1A1B2E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Level grid (1,000 levels)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: totalLevels,
              itemBuilder: (context, index) {
                final level = index + 1;
                return LevelTile(
                  level: level,
                  isJumbled: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JumbledGameScreen(level: level),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
