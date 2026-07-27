// Screens: HomeScreen — main landing screen with game section selection
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_language.dart';
import '../providers/progress_provider.dart';
import '../utils/app_theme.dart';
import 'game_screen.dart';
import 'jumbled_game_screen.dart';
import 'jumbled_level_select_screen.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';

enum GameSection { wordSearch, jumbledWords }

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
    final currentStars = isWordSearch
        ? progress.totalStars
        : progress.jumbledTotalStars;
    final currentLevel = isWordSearch
        ? progress.highestUnlockedLevel
        : progress.jumbledHighestUnlockedLevel;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background blobs
            _buildBg(isDark),
            // Main content
            Column(
              children: [
                // Top Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Stars Badge
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                      // Language & Settings
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1A1B2E)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppLanguage.fromCode(progress.languageCode)
                                        .flag,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLanguage.fromCode(progress.languageCode)
                                        .code
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: isDark
                                          ? const Color(0xFF8B84FF)
                                          : const Color(0xFF6C63FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
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
                    ],
                  ),
                ),
                const SizedBox(height: 12),

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
                            onTap: () {
                              setState(() {
                                _selectedSection = GameSection.wordSearch;
                              });
                            },
                            isDark: isDark,
                          ),
                        ),
                        Expanded(
                          child: _SectionTab(
                            title: 'Jumbled Words',
                            icon: Icons.shuffle_rounded,
                            isSelected: !isWordSearch,
                            onTap: () {
                              setState(() {
                                _selectedSection = GameSection.jumbledWords;
                              });
                            },
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Animated Title & Logo for selected Game Section
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
                                            const Color(0xFF00C9A7),
                                            const Color(0xFF3A86FF)
                                          ]
                                        : [
                                            const Color(0xFF00C9A7),
                                            const Color(0xFF8338EC)
                                          ]),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryLight
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
                                    : Icons.text_fields_rounded,
                                color: Colors.white,
                                size: 52,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isWordSearch ? 'Word Search' : 'Jumbled Words',
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
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              isWordSearch
                                  ? 'Find all hidden words in the letter grid!'
                                  : 'Unscramble letters to reveal target words!',
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
                            : const [Color(0xFF00C9A7), Color(0xFF3A86FF)],
                        onTap: () {
                          if (isWordSearch) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GameScreen(level: currentLevel),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    JumbledGameScreen(level: currentLevel),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      _OutlinedActionButton(
                        label: '1,000 Levels',
                        icon: Icons.grid_view_rounded,
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
                                      const JumbledLevelSelectScreen()),
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

  Widget _buildBg(bool isDark) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: _Blob(
                color: isDark
                    ? const Color(0xFF8B84FF)
                    : const Color(0xFF6C63FF),
                size: 220,
                opacity: 0.12,
              ),
            ),
            Positioned(
              bottom: -80,
              right: -60,
              child: _Blob(
                color: isDark
                    ? const Color(0xFF00E5BE)
                    : const Color(0xFF00C9A7),
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
  final VoidCallback onTap;
  final bool isDark;

  const _SectionTab({
    required this.title,
    required this.icon,
    required this.isSelected,
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
              ? (isDark ? const Color(0xFF6C63FF) : Colors.white)
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
                  ? (isDark ? Colors.white : const Color(0xFF6C63FF))
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF6C63FF))
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

  const _Blob({required this.color, required this.size, required this.opacity});

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
  final VoidCallback onTap;
  final bool isDark;

  const _OutlinedActionButton(
      {required this.label,
      required this.icon,
      required this.onTap,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isDark
                    ? const Color(0xFF8B84FF)
                    : const Color(0xFF6C63FF),
                size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF8B84FF)
                    : const Color(0xFF6C63FF),
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
