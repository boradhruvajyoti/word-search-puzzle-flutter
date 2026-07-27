// Unit tests: ProgressProvider Star Rewarding System
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_search_puzzle/providers/progress_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProgressProvider Star Rewarding System', () {
    test('initial totalStars is 0', () async {
      final progress = ProgressProvider();
      await progress.load();
      expect(progress.totalStars, 0);
    });

    test('rewards as many stars as seconds left on level completion', () async {
      final progress = ProgressProvider();
      await progress.load();

      // Complete level 1 with 45 seconds remaining
      await progress.completeLevel(1, 45);
      expect(progress.totalStars, 45);

      // Complete level 2 with 30 seconds remaining
      await progress.completeLevel(2, 30);
      expect(progress.totalStars, 75); // 45 + 30
    });

    test('deducts total time limit on level failure', () async {
      final progress = ProgressProvider();
      await progress.load();

      // Earn 100 stars first
      await progress.completeLevel(1, 100);
      expect(progress.totalStars, 100);

      // Fail a level with time limit of 60 seconds
      await progress.failLevel(2, 60);
      expect(progress.totalStars, 40); // 100 - 60
    });

    test('totalStars does not go below 0 when deducted on failure', () async {
      final progress = ProgressProvider();
      await progress.load();

      // Earn 30 stars
      await progress.completeLevel(1, 30);
      expect(progress.totalStars, 30);

      // Fail a level with time limit of 75 seconds -> 30 - 75 = -45 => clamped to 0
      await progress.failLevel(2, 75);
      expect(progress.totalStars, 0);
    });

    test('resetProgress resets totalStars to 0', () async {
      final progress = ProgressProvider();
      await progress.load();
      await progress.completeLevel(1, 50);
      expect(progress.totalStars, 50);

      await progress.resetProgress();
      expect(progress.totalStars, 0);
    });
  });
}
