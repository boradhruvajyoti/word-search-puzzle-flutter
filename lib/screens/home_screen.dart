// Screens: HomeScreen — main landing screen with game section selection (Word Search, Sudoku, Cryptogram, Quadsum)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/app_theme.dart';
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
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
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
            Column(
              children: [
                // Top Header Row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
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
                ),
                const SizedBox(height: 4),

                // Game Section Segmented Control Switcher (4 Games)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1A1B2E)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SectionTab(
                            title: 'Word',
                            icon: Icons.grid_on_rounded,
                            isSelected:
                                _selectedSection == GameSection.wordSearch,
                            selectedColor: const Color(0xFF6C63FF),
                            onTap: () => _selectSection(GameSection.wordSearch),
                            isDark: isDark,
                          ),
                        ),
                        Expanded(
                          child: _SectionTab(
                            title: 'Sudoku',
                            icon: Icons.grid_4x4_rounded,
                            isSelected: _selectedSection == GameSection.sudoku,
                            selectedColor: const Color(0xFF3A86FF),
                            onTap: () => _selectSection(GameSection.sudoku),
                            isDark: isDark,
                          ),
                        ),
                        Expanded(
                          child: _SectionTab(
                            title: 'Crypto',
                            icon: Icons.psychology_rounded,
                            isSelected:
                                _selectedSection == GameSection.cryptogram,
                            selectedColor: const Color(0xFF8338EC),
                            onTap: () => _selectSection(GameSection.cryptogram),
                            isDark: isDark,
                          ),
                        ),
                        Expanded(
                          child: _SectionTab(
                            title: 'Quadsum',
                            icon: Icons.calculate_rounded,
                            isSelected: _selectedSection == GameSection.quadsum,
                            selectedColor: const Color(0xFF00B4D8),
                            onTap: () => _selectSection(GameSection.quadsum),
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Animated Title & Logo for selected section
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) => FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: switch (_selectedSection) {
                                  GameSection.wordSearch => isDark
                                      ? [
                                          const Color(0xFF8B84FF),
                                          const Color(0xFF00E5BE)
                                        ]
                                      : [
                                          const Color(0xFF6C63FF),
                                          const Color(0xFF00C9A7)
                                        ],
                                  GameSection.sudoku => isDark
                                      ? [
                                          const Color(0xFF3A86FF),
                                          const Color(0xFF8B84FF)
                                        ]
                                      : [
                                          const Color(0xFF3A86FF),
                                          const Color(0xFF6C63FF)
                                        ],
                                  GameSection.cryptogram => isDark
                                      ? [
                                          const Color(0xFF8338EC),
                                          const Color(0xFFFF006E)
                                        ]
                                      : [
                                          const Color(0xFF8338EC),
                                          const Color(0xFFFF006E)
                                        ],
                                  GameSection.quadsum => isDark
                                      ? [
                                          const Color(0xFF00B4D8),
                                          const Color(0xFF06D6A0)
                                        ]
                                      : [
                                          const Color(0xFF00B4D8),
                                          const Color(0xFF06D6A0)
                                        ],
                                },
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: (switch (_selectedSection) {
                                    GameSection.wordSearch =>
                                      AppTheme.primaryLight,
                                    GameSection.sudoku =>
                                      const Color(0xFF3A86FF),
                                    GameSection.cryptogram =>
                                      const Color(0xFF8338EC),
                                    GameSection.quadsum =>
                                      const Color(0xFF00B4D8),
                                  })
                                      .withValues(alpha: 0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                switch (_selectedSection) {
                                  GameSection.wordSearch =>
                                    Icons.search_rounded,
                                  GameSection.sudoku => Icons.grid_4x4_rounded,
                                  GameSection.cryptogram =>
                                    Icons.psychology_rounded,
                                  GameSection.quadsum =>
                                    Icons.calculate_rounded,
                                },
                                color: Colors.white,
                                size: 52,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            switch (_selectedSection) {
                              GameSection.wordSearch => 'Word Search',
                              GameSection.sudoku => 'Sudoku',
                              GameSection.cryptogram => 'Cryptogram',
                              GameSection.quadsum => 'Quadsum',
                            },
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? const Color(0xFFE8E9FF)
                                  : const Color(0xFF1A1B2E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              switch (_selectedSection) {
                                GameSection.wordSearch =>
                                  'Find all hidden words in the letter grid!',
                                GameSection.sudoku =>
                                  'Fill the 9×9 grid — no repeats in rows, columns or boxes!',
                                GameSection.cryptogram =>
                                  'Decipher famous quotes and timeless wisdom letter by letter!',
                                GameSection.quadsum =>
                                  'Place digits 1–9 so all 4 intersection circle sums match!',
                              },
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? (switch (_selectedSection) {
                                        GameSection.wordSearch =>
                                          const Color(0xFF8B84FF),
                                        GameSection.sudoku =>
                                          const Color(0xFF8B84FF),
                                        GameSection.cryptogram =>
                                          const Color(0xFFC77DFF),
                                        GameSection.quadsum =>
                                          const Color(0xFF38BDF8),
                                      })
                                    : (switch (_selectedSection) {
                                        GameSection.wordSearch =>
                                          const Color(0xFF6C63FF),
                                        GameSection.sudoku =>
                                          const Color(0xFF3A86FF),
                                        GameSection.cryptogram =>
                                          const Color(0xFF8338EC),
                                        GameSection.quadsum =>
                                          const Color(0xFF00B4D8),
                                      }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Play & Levels Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
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
                      const SizedBox(height: 14),
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
                const SizedBox(height: 48),
              ],
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

class _SectionTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;
  final bool isDark;

  const _SectionTab({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? selectedColor : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? (isDark ? Colors.white : selectedColor)
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? (isDark ? Colors.white : selectedColor)
                    : (isDark ? Colors.white60 : Colors.black54),
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
        height: 60,
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
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: btnColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: btnColor, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: btnColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
