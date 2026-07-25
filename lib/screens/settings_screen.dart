// Screens: SettingsScreen — sound, theme, reset progress
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader(title: 'Preferences', isDark: isDark),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            label: 'Dark Mode',
            isDark: isDark,
            trailing: Switch.adaptive(
              value: progress.darkMode,
              onChanged: (v) => progress.setDarkMode(v),
              activeThumbColor: const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.volume_up_rounded,
            label: 'Sound Effects',
            isDark: isDark,
            trailing: Switch.adaptive(
              value: progress.soundEnabled,
              onChanged: (v) => progress.setSoundEnabled(v),
              activeThumbColor: const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Data', isDark: isDark),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.restart_alt_rounded,
            label: 'Reset Progress',
            isDark: isDark,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _confirmReset(context, progress),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(
      BuildContext context, ProgressProvider progress) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Progress?'),
        content: const Text(
            'This will clear all unlocked levels and best times. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset',
                style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await progress.resetProgress();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress reset successfully.')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: isDark ? const Color(0xFF8B84FF) : const Color(0xFF6C63FF),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final bool isDark;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1B2E) : Colors.white,
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF242540)
                    : const Color(0xFFF0F2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: isDark
                      ? const Color(0xFF8B84FF)
                      : const Color(0xFF6C63FF),
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE8E9FF)
                      : const Color(0xFF1A1B2E),
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
