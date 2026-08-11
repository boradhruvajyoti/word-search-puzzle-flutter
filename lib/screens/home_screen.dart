// Screens: HomeScreen — main landing screen with game section selection
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/app_theme.dart';
import 'game_screen.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';
import 'sudoku_game_screen.dart';
import 'sudoku_level_select_screen.dart';

enum GameSection { wordSearch, sudoku }

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

    final isWordSearch = _selectedSection == GameSection.wordSearch;

    final currentStars = progress.totalStars;
    final currentLevel = isWordSearch
        ? progress.highestUnlockedLevel
        : progress.sudokuHighestUnlockedLevel;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background blobs
            _buildBg(isDark, isWordSearch),
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

                // Game Section Segmented Control Switcher
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                            title: 'Word Search',
                            icon: Icons.grid_on_rounded,
                            isSelected: isWordSearch,
                            selectedColor: const Color(0xFF6C63FF),
                            onTap: () {
                              setState(() {
                                _selectedSection = GameSection.wordSearch;
                              });
                              _logoController
                                ..reset()
                                ..forward();
                            },
                            isDark: isDark,
                          ),
                        ),
                        Expanded(
                          child: _SectionTab(
                            title: 'Sudoku',
                            icon: Icons.grid_4x4_rounded,
                            isSelected: !isWordSearch,
                            selectedColor: const Color(0xFF3A86FF),
                            onTap: () {
                              setState(() {
                                _selectedSection = GameSection.sudoku;
                              });
                              _logoController
                                ..reset()
                                ..forward();
                            },
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
                                colors: isWordSearch
                                    ? (isDark
                                        ? [
                                            const Color(0xFF8B84FF),
                                            const Color(0xFF00E5BE)
                                          ]
                                        : [
                                            const Color(0xFF6C63FF),
                                            const Color(0xFF00C9A7)
                                          ])
                                    : (isDark
                                        ? [
                                            const Color(0xFF3A86FF),
                                            const Color(0xFF8B84FF)
                                          ]
                                        : [
                                            const Color(0xFF3A86FF),
                                            const Color(0xFF6C63FF)
                                          ]),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: (isWordSearch
                                          ? AppTheme.primaryLight
                                          : const Color(0xFF3A86FF))
                                      .withValues(alpha: 0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                isWordSearch
                                    ? Icons.search_rounded
                                    : Icons.grid_4x4_rounded,
                                color: Colors.white,
                                size: 52,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isWordSearch ? 'Word Search' : 'Sudoku',
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
                              isWordSearch
                                  ? 'Find all hidden words in the letter grid!'
                                  : 'Fill the 9×9 grid — no repeats in rows, columns or boxes!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? const Color(0xFF8B84FF)
                                    : const Color(0xFF6C63FF),
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
                        gradientColors: isWordSearch
                            ? const [Color(0xFF6C63FF), Color(0xFF00C9A7)]
                            : const [Color(0xFF3A86FF), Color(0xFF6C63FF)],
                        onTap: () {
                          if (isWordSearch) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    GameScreen(level: currentLevel),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SudokuGameScreen(level: currentLevel),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      _OutlinedActionButton(
                        label: '1,000 Levels',
                        icon: Icons.grid_view_rounded,
                        color: isWordSearch
                            ? const Color(0xFF6C63FF)
                            : const Color(0xFF3A86FF),
                        onTap: () {
                          if (isWordSearch) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LevelSelectScreen()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const SudokuLevelSelectScreen()),
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

  Widget _buildBg(bool isDark, bool isWordSearch) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: _Blob(
                color: isWordSearch
                    ? (isDark
                        ? const Color(0xFF8B84FF)
                        : const Color(0xFF6C63FF))
                    : (isDark
                        ? const Color(0xFF3A86FF)
                        : const Color(0xFF3A86FF)),
                size: 220,
                opacity: 0.12,
              ),
            ),
            Positioned(
              bottom: -80,
              right: -60,
              child: _Blob(
                color: isWordSearch
                    ? (isDark
                        ? const Color(0xFF00E5BE)
                        : const Color(0xFF00C9A7))
                    : (isDark
                        ? const Color(0xFF8B84FF)
                        : const Color(0xFF6C63FF)),
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
              size: 18,
              color: isSelected
                  ? (isDark ? Colors.white : selectedColor)
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
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
    final btnColor =
        isDark ? color.withValues(alpha: 0.8) : color;
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
