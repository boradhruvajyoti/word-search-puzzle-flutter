// Screens: HomeScreen — landing screen displaying all 4 games on 2-column cards
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/retry_ad_dialog.dart';
import 'cryptogram_game_screen.dart';
import 'cryptogram_level_select_screen.dart';
import 'game_screen.dart';
import 'level_select_screen.dart';
import 'quadsum_game_screen.dart';
import 'quadsum_level_select_screen.dart';
import 'settings_screen.dart';
import 'sudoku_game_screen.dart';
import 'sudoku_level_select_screen.dart';

enum GameSection { wordSearch, sudoku, cryptogram, quadsum }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  GameSection _selectedSection = GameSection.wordSearch;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = context.watch<ProgressProvider>();

    final currentStars = progress.totalStars;
    final currentLevel = switch (_selectedSection) {
      GameSection.wordSearch => progress.highestUnlockedLevel,
      GameSection.sudoku => progress.sudokuHighestUnlockedLevel,
      GameSection.cryptogram => progress.cryptogramHighestUnlockedLevel,
      GameSection.quadsum => progress.quadsumHighestUnlockedLevel,
    };

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background blobs
            _buildBg(isDark, _selectedSection),
            // Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Top Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Stars Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1B2E)
                              : const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFFFBE0B), size: 22),
                            const SizedBox(width: 6),
                            Text(
                              '$currentStars',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? const Color(0xFFE8E9FF)
                                    : const Color(0xFF1A1B2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Title Text
                      Text(
                        'Puzzle Arcade',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? const Color(0xFFE8E9FF)
                              : const Color(0xFF1A1B2E),
                        ),
                      ),
                      // Settings Button
                      IconButton(
                        icon: const Icon(Icons.settings_rounded),
                        iconSize: 28,
                        color: isDark
                            ? const Color(0xFF8B84FF)
                            : const Color(0xFF6C63FF),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2-Column Game Selection Cards (Row 1: Word Search, Sudoku)
                  Row(
                    children: [
                      Expanded(
                        child: _GameCard(
                          title: 'Word Search',
                          subtitle: 'Find hidden words',
                          icon: Icons.search_rounded,
                          level: progress.highestUnlockedLevel,
                          gradientColors: const [
                            Color(0xFF6C63FF),
                            Color(0xFF00C9A7),
                          ],
                          isSelected: _selectedSection == GameSection.wordSearch,
                          isDark: isDark,
                          onTap: () {
                            if (_selectedSection == GameSection.wordSearch) {
                              _handlePlay(context, progress, progress.highestUnlockedLevel);
                            } else {
                              _selectSection(GameSection.wordSearch);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _GameCard(
                          title: 'Sudoku',
                          subtitle: '9×9 number grid',
                          icon: Icons.grid_4x4_rounded,
                          level: progress.sudokuHighestUnlockedLevel,
                          gradientColors: const [
                            Color(0xFF3A86FF),
                            Color(0xFF6C63FF),
                          ],
                          isSelected: _selectedSection == GameSection.sudoku,
                          isDark: isDark,
                          onTap: () {
                            if (_selectedSection == GameSection.sudoku) {
                              _handlePlay(context, progress, progress.sudokuHighestUnlockedLevel);
                            } else {
                              _selectSection(GameSection.sudoku);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 2-Column Game Selection Cards (Row 2: Cryptogram, Quadsum)
                  Row(
                    children: [
                      Expanded(
                        child: _GameCard(
                          title: 'Cryptogram',
                          subtitle: 'Decipher quotes',
                          icon: Icons.psychology_rounded,
                          level: progress.cryptogramHighestUnlockedLevel,
                          gradientColors: const [
                            Color(0xFF8338EC),
                            Color(0xFFFF006E),
                          ],
                          isSelected: _selectedSection == GameSection.cryptogram,
                          isDark: isDark,
                          onTap: () {
                            if (_selectedSection == GameSection.cryptogram) {
                              _handlePlay(context, progress, progress.cryptogramHighestUnlockedLevel);
                            } else {
                              _selectSection(GameSection.cryptogram);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _GameCard(
                          title: 'Quadsum',
                          subtitle: 'Quadrant sums',
                          icon: Icons.calculate_rounded,
                          level: progress.quadsumHighestUnlockedLevel,
                          gradientColors: const [
                            Color(0xFF00B4D8),
                            Color(0xFF06D6A0),
                          ],
                          isSelected: _selectedSection == GameSection.quadsum,
                          isDark: isDark,
                          onTap: () {
                            if (_selectedSection == GameSection.quadsum) {
                              _handlePlay(context, progress, progress.quadsumHighestUnlockedLevel);
                            } else {
                              _selectSection(GameSection.quadsum);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Animated Game Info Banner for Selected Game
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF141526)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              switch (_selectedSection) {
                                GameSection.wordSearch => Icons.search_rounded,
                                GameSection.sudoku => Icons.grid_4x4_rounded,
                                GameSection.cryptogram => Icons.psychology_rounded,
                                GameSection.quadsum => Icons.calculate_rounded,
                              },
                              color: switch (_selectedSection) {
                                GameSection.wordSearch => const Color(0xFF6C63FF),
                                GameSection.sudoku => const Color(0xFF3A86FF),
                                GameSection.cryptogram => const Color(0xFF8338EC),
                                GameSection.quadsum => const Color(0xFF00B4D8),
                              },
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                switch (_selectedSection) {
                                  GameSection.wordSearch =>
                                    'Swipe letters horizontally, vertically, or diagonally.',
                                  GameSection.sudoku =>
                                    'Fill the 9×9 grid without repeating numbers in rows, cols, or 3×3s.',
                                  GameSection.cryptogram =>
                                    'Decipher famous quotes and timeless wisdom letter by letter.',
                                  GameSection.quadsum =>
                                    'Place digits 1–9 so all 4 intersection circle sums match.',
                                },
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : const Color(0xFF4A4B6E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Play & Levels Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        _GradientButton(
                          label: 'Play Level $currentLevel',
                          icon: Icons.play_arrow_rounded,
                          gradientColors: switch (_selectedSection) {
                            GameSection.wordSearch => const [
                                Color(0xFF6C63FF),
                                Color(0xFF00C9A7)
                              ],
                            GameSection.sudoku => const [
                                Color(0xFF3A86FF),
                                Color(0xFF6C63FF)
                              ],
                            GameSection.cryptogram => const [
                                Color(0xFF8338EC),
                                Color(0xFFFF006E)
                              ],
                            GameSection.quadsum => const [
                                Color(0xFF00B4D8),
                                Color(0xFF06D6A0)
                              ],
                          },
                          onTap: () => _handlePlay(context, progress, currentLevel),
                        ),
                        const SizedBox(height: 12),
                        _OutlinedActionButton(
                          label: '1,000 Levels',
                          icon: Icons.grid_view_rounded,
                          color: switch (_selectedSection) {
                            GameSection.wordSearch => const Color(0xFF6C63FF),
                            GameSection.sudoku => const Color(0xFF3A86FF),
                            GameSection.cryptogram => const Color(0xFF8338EC),
                            GameSection.quadsum => const Color(0xFF00B4D8),
                          },
                          onTap: () {
                            switch (_selectedSection) {
                              case GameSection.wordSearch:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LevelSelectScreen()),
                                );
                              case GameSection.sudoku:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const SudokuLevelSelectScreen()),
                                );
                              case GameSection.cryptogram:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const CryptogramLevelSelectScreen()),
                                );
                              case GameSection.quadsum:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const QuadsumLevelSelectScreen()),
                                );
                            }
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePlay(BuildContext context, ProgressProvider progress, int level) {
    if (_selectedSection == GameSection.wordSearch) {
      if (progress.isRetryAdRequired(level)) {
        RetryAdDialog.show(
          context,
          level: level,
          isSudoku: false,
          onAdCompleted: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GameScreen(level: level)),
            );
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GameScreen(level: level)),
        );
      }
    } else if (_selectedSection == GameSection.sudoku) {
      if (progress.isSudokuRetryAdRequired(level)) {
        RetryAdDialog.show(
          context,
          level: level,
          isSudoku: true,
          onAdCompleted: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SudokuGameScreen(level: level)),
            );
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SudokuGameScreen(level: level)),
        );
      }
    } else if (_selectedSection == GameSection.cryptogram) {
      if (progress.isCryptogramRetryAdRequired(level)) {
        RetryAdDialog.show(
          context,
          level: level,
          isCryptogram: true,
          onAdCompleted: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CryptogramGameScreen(level: level)),
            );
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CryptogramGameScreen(level: level)),
        );
      }
    } else {
      if (progress.isQuadsumRetryAdRequired(level)) {
        RetryAdDialog.show(
          context,
          level: level,
          isQuadsum: true,
          onAdCompleted: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => QuadsumGameScreen(level: level)),
            );
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => QuadsumGameScreen(level: level)),
        );
      }
    }
  }

  void _selectSection(GameSection section) {
    if (_selectedSection == section) return;
    setState(() {
      _selectedSection = section;
    });
    _logoController
      ..reset()
      ..forward();
  }

  Widget _buildBg(bool isDark, GameSection section) {
    final c1 = switch (section) {
      GameSection.wordSearch =>
        isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
      GameSection.sudoku => const Color(0xFF3A86FF),
      GameSection.cryptogram =>
        isDark ? const Color(0xFF8338EC) : const Color(0xFF7209B7),
      GameSection.quadsum =>
        isDark ? const Color(0xFF00B4D8) : const Color(0xFF0077B6),
    };
    final c2 = switch (section) {
      GameSection.wordSearch =>
        isDark ? const Color(0xFF00E5BE) : const Color(0xFF00C9A7),
      GameSection.sudoku =>
        isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
      GameSection.cryptogram => const Color(0xFFFF006E),
      GameSection.quadsum => const Color(0xFF06D6A0),
    };

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: _Blob(
                color: c1,
                size: 220,
                opacity: 0.12,
              ),
            ),
            Positioned(
              bottom: -80,
              right: -60,
              child: _Blob(
                color: c2,
                size: 260,
                opacity: 0.10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 2-Column Game Card ────────────────────────────────────────────────────────

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int level;
  final List<Color> gradientColors;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.level,
    required this.gradientColors,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = gradientColors.first;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: isDark ? 0.22 : 0.12)
              : (isDark ? const Color(0xFF1A1B2E) : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? primary
                : (isDark ? const Color(0xFF2E3150) : const Color(0xFFE2E8F0)),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Level Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: isDark ? 0.25 : 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Lvl $level',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bottom Column: Title + Subtitle
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? const Color(0xFFE8E9FF)
                    : const Color(0xFF1A1B2E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _Blob(
      {required this.color, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _OutlinedActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = isDark ? color.withValues(alpha: 0.8) : color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: btnColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: btnColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: btnColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
