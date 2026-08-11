// Widgets: UnlockLevelDialog — shared dialog for unlocking locked levels with stars
import 'package:flutter/material.dart';

class UnlockLevelDialog extends StatelessWidget {
  final int level;
  final int cost;
  final int currentStars;
  final bool canAfford;
  final bool isDark;

  const UnlockLevelDialog({
    super.key,
    required this.level,
    required this.cost,
    required this.currentStars,
    required this.canAfford,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1A1B2E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFBE0B), Color(0xFFFF9E00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFBE0B).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.lock_open_rounded,
                  color: Colors.white, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              'Unlock Level $level',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? const Color(0xFFE8E9FF)
                    : const Color(0xFF1A1B2E),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Spend stars to skip ahead and play this level immediately.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? const Color(0xFF8B84FF)
                    : const Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 18),
            // Cost row
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF242540)
                    : const Color(0xFFF0F2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cost',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF8B84FF)
                          : const Color(0xFF6C63FF),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFBE0B), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '$cost stars',
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
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Balance row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your balance: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                const Icon(Icons.star_rounded,
                    color: Color(0xFFFFBE0B), size: 15),
                const SizedBox(width: 3),
                Text(
                  '$currentStars stars',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: canAfford
                        ? const Color(0xFF06D6A0)
                        : const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
            if (!canAfford) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.4)),
                ),
                child: const Text(
                  'Not enough stars — earn more by completing levels!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF4A4B6E)
                            : const Color(0xFFCCCCDD),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF8B84FF)
                            : const Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        canAfford ? () => Navigator.pop(context, true) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFBE0B),
                      disabledBackgroundColor: isDark
                          ? const Color(0xFF3A3B58)
                          : const Color(0xFFE0E0E0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: canAfford ? 4 : 0,
                      shadowColor:
                          const Color(0xFFFFBE0B).withValues(alpha: 0.4),
                    ),
                    child: Text(
                      'Unlock & Play',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: canAfford ? Colors.white : Colors.white54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
