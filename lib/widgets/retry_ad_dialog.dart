// Widgets: RetryAdDialog — dialog shown when replaying a failed level requiring a rewarded ad
import 'package:flutter/material.dart';
import '../logic/ad_helper.dart';

class RetryAdDialog extends StatelessWidget {
  final int level;
  final bool isSudoku;
  final bool isCryptogram;
  final bool isQuadsum;
  final VoidCallback onAdCompleted;

  const RetryAdDialog({
    super.key,
    required this.level,
    this.isSudoku = false,
    this.isCryptogram = false,
    this.isQuadsum = false,
    required this.onAdCompleted,
  });

  /// Static helper to show the dialog
  static Future<void> show(
    BuildContext context, {
    required int level,
    bool isSudoku = false,
    bool isCryptogram = false,
    bool isQuadsum = false,
    required VoidCallback onAdCompleted,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => RetryAdDialog(
        level: level,
        isSudoku: isSudoku,
        isCryptogram: isCryptogram,
        isQuadsum: isQuadsum,
        onAdCompleted: onAdCompleted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = isQuadsum
        ? 'Quadsum Level $level'
        : (isCryptogram
            ? 'Cryptogram Level $level'
            : (isSudoku ? 'Sudoku Level $level' : 'Level $level'));
    final primaryColor = isQuadsum
        ? const Color(0xFF00B4D8)
        : (isCryptogram
            ? const Color(0xFF8338EC)
            : (isSudoku ? const Color(0xFF3A86FF) : const Color(0xFF6C63FF)));
    final secondaryColor = isQuadsum
        ? const Color(0xFF06D6A0)
        : (isCryptogram
            ? const Color(0xFFFF006E)
            : (isSudoku ? const Color(0xFF6C63FF) : const Color(0xFF00C9A7)));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1A1B2E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Video Ad Icon with gradient circle
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.ondemand_video_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Retry $title',
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
              'You have used your 2 free attempts on this level. Watch a short video ad to unlock this retry!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isDark
                    ? const Color(0xFF8B84FF)
                    : const Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF4A4B6E)
                            : const Color(0xFFCCCCDD),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close dialog first
                      AdHelper.showRewardedAd(
                        onRewardGranted: onAdCompleted,
                        onAdClosed: () {},
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text(
                            'Watch Ad',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
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
