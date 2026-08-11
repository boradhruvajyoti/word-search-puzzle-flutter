import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_search_puzzle/providers/progress_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProgressProvider Star Unlock', () {
    test('starCostToUnlock calculates cost as 5x level', () {
      expect(ProgressProvider.starCostToUnlock(1), 5);
      expect(ProgressProvider.starCostToUnlock(10), 50);
      expect(ProgressProvider.starCostToUnlock(50), 250);
      expect(ProgressProvider.starCostToUnlock(100), 500);
    });

    test('unlockLevelWithStars deducts stars and unlocks Word Search level', () async {
      final provider = ProgressProvider();
      // Initially level 50 is locked
      expect(provider.isLevelUnlocked(50), isFalse);

      // Earn 300 stars by completing level 1 with 300s remaining
      await provider.completeLevel(1, 300);
      expect(provider.totalStars, 300);

      // Cost for level 50 is 50 * 5 = 250
      expect(provider.canAffordUnlock(50), isTrue);

      final success = await provider.unlockLevelWithStars(50);
      expect(success, isTrue);
      expect(provider.totalStars, 50); // 300 - 250
      expect(provider.isLevelUnlocked(50), isTrue);
    });

    test('unlockSudokuLevelWithStars deducts stars and unlocks Sudoku level', () async {
      final provider = ProgressProvider();
      expect(provider.isSudokuLevelUnlocked(20), isFalse);

      await provider.completeSudokuLevel(1, 150);
      expect(provider.totalStars, 150);

      // Cost for level 20 is 20 * 5 = 100
      expect(provider.canAffordUnlock(20), isTrue);

      final success = await provider.unlockSudokuLevelWithStars(20);
      expect(success, isTrue);
      expect(provider.totalStars, 50); // 150 - 100
      expect(provider.isSudokuLevelUnlocked(20), isTrue);
    });

    test('star unlocking level 50 does not unlock intermediate unplayed levels (2..49)', () async {
      final provider = ProgressProvider();
      await provider.completeLevel(1, 300);
      await provider.unlockLevelWithStars(50);

      expect(provider.isLevelUnlocked(1), isTrue);
      expect(provider.isLevelUnlocked(2), isTrue); // unlocked by completing level 1
      expect(provider.isLevelUnlocked(3), isFalse); // level 2 not completed
      expect(provider.isLevelUnlocked(25), isFalse);
      expect(provider.isLevelUnlocked(49), isFalse);
      expect(provider.isLevelUnlocked(50), isTrue); // star unlocked
      expect(provider.isLevelUnlocked(51), isFalse); // level 50 not completed yet

      // Completing level 50 unlocks level 51, but levels 3..49 MUST remain locked
      await provider.completeLevel(50, 100);

      expect(provider.isLevelUnlocked(50), isTrue);
      expect(provider.isLevelUnlocked(51), isTrue);
      expect(provider.isLevelUnlocked(3), isFalse);
      expect(provider.isLevelUnlocked(25), isFalse);
      expect(provider.isLevelUnlocked(49), isFalse);
    });
  });
}
