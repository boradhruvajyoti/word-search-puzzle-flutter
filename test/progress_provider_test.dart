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
      expect(provider.isLevelUnlocked(50), isFalse);

      await provider.completeLevel(1, 300);
      expect(provider.wordSearchStars, 300);
      expect(provider.totalStars, 300);

      expect(provider.canAffordUnlock(50), isTrue);

      final success = await provider.unlockLevelWithStars(50);
      expect(success, isTrue);
      expect(provider.wordSearchStars, 50);
      expect(provider.isLevelUnlocked(50), isTrue);
    });

    test('unlockSudokuLevelWithStars deducts stars and unlocks Sudoku level', () async {
      final provider = ProgressProvider();
      expect(provider.isSudokuLevelUnlocked(20), isFalse);

      await provider.completeSudokuLevel(1, 150);
      expect(provider.sudokuStars, 150);
      expect(provider.totalStars, 150);

      expect(provider.canAffordSudokuUnlock(20), isTrue);

      final success = await provider.unlockSudokuLevelWithStars(20);
      expect(success, isTrue);
      expect(provider.sudokuStars, 50);
      expect(provider.isSudokuLevelUnlocked(20), isTrue);
    });

    test('unlockCryptogramLevelWithStars deducts stars and unlocks Cryptogram level', () async {
      final provider = ProgressProvider();
      expect(provider.isCryptogramLevelUnlocked(15), isFalse);

      await provider.completeCryptogramLevel(1, 100);
      expect(provider.cryptogramStars, 100);
      expect(provider.totalStars, 100);

      expect(provider.canAffordCryptogramUnlock(15), isTrue);

      final success = await provider.unlockCryptogramLevelWithStars(15);
      expect(success, isTrue);
      expect(provider.cryptogramStars, 25);
      expect(provider.isCryptogramLevelUnlocked(15), isTrue);
    });

    test('unlockQuadsumLevelWithStars deducts stars and unlocks Quadsum level', () async {
      final provider = ProgressProvider();
      expect(provider.isQuadsumLevelUnlocked(25), isFalse);

      await provider.completeQuadsumLevel(1, 200);
      expect(provider.quadsumStars, 200);
      expect(provider.totalStars, 200);

      expect(provider.canAffordQuadsumUnlock(25), isTrue); // 25 * 5 = 125

      final success = await provider.unlockQuadsumLevelWithStars(25);
      expect(success, isTrue);
      expect(provider.quadsumStars, 75); // 200 - 125
      expect(provider.isQuadsumLevelUnlocked(25), isTrue);
    });

    test('stars won from one game cannot unlock levels in another game', () async {
      final provider = ProgressProvider();

      // Earn 500 stars in Word Search
      await provider.completeLevel(1, 500);
      expect(provider.wordSearchStars, 500);
      expect(provider.sudokuStars, 0);
      expect(provider.cryptogramStars, 0);
      expect(provider.quadsumStars, 0);

      // Try unlocking level 10 in Sudoku (requires 50 stars) -> should FAIL
      expect(provider.canAffordSudokuUnlock(10), isFalse);
      final sudokuSuccess = await provider.unlockSudokuLevelWithStars(10);
      expect(sudokuSuccess, isFalse);
      expect(provider.isSudokuLevelUnlocked(10), isFalse);

      // Try unlocking level 10 in Cryptogram -> should FAIL
      expect(provider.canAffordCryptogramUnlock(10), isFalse);
      final cryptoSuccess = await provider.unlockCryptogramLevelWithStars(10);
      expect(cryptoSuccess, isFalse);
      expect(provider.isCryptogramLevelUnlocked(10), isFalse);

      // Try unlocking level 10 in Quadsum -> should FAIL
      expect(provider.canAffordQuadsumUnlock(10), isFalse);
      final quadSuccess = await provider.unlockQuadsumLevelWithStars(10);
      expect(quadSuccess, isFalse);
      expect(provider.isQuadsumLevelUnlocked(10), isFalse);

      // Word search level 10 CAN be unlocked
      expect(provider.canAffordUnlock(10), isTrue);
      final wsSuccess = await provider.unlockLevelWithStars(10);
      expect(wsSuccess, isTrue);
      expect(provider.wordSearchStars, 450);
    });
  });

  group('ProgressProvider 2 Free Attempts & Rewarded Ad Tracking', () {
    test('initial state has 2 free attempts remaining across all games', () {
      final provider = ProgressProvider();
      expect(provider.remainingFreeAttempts(1), 2);
      expect(provider.isRetryAdRequired(1), isFalse);

      expect(provider.sudokuRemainingFreeAttempts(1), 2);
      expect(provider.isSudokuRetryAdRequired(1), isFalse);

      expect(provider.cryptogramRemainingFreeAttempts(1), 2);
      expect(provider.isCryptogramRetryAdRequired(1), isFalse);

      expect(provider.quadsumRemainingFreeAttempts(1), 2);
      expect(provider.isQuadsumRetryAdRequired(1), isFalse);
    });

    test('first failure leaves 1 free attempt and does NOT require ad', () async {
      final provider = ProgressProvider();

      // Word Search 1st fail
      await provider.failLevel(1, 60);
      expect(provider.remainingFreeAttempts(1), 1);
      expect(provider.isRetryAdRequired(1), isFalse);

      // Sudoku 1st fail
      await provider.failSudokuLevel(2, 120);
      expect(provider.sudokuRemainingFreeAttempts(2), 1);
      expect(provider.isSudokuRetryAdRequired(2), isFalse);

      // Cryptogram 1st fail
      await provider.failCryptogramLevel(3, 180);
      expect(provider.cryptogramRemainingFreeAttempts(3), 1);
      expect(provider.isCryptogramRetryAdRequired(3), isFalse);

      // Quadsum 1st fail
      await provider.failQuadsumLevel(4, 150);
      expect(provider.quadsumRemainingFreeAttempts(4), 1);
      expect(provider.isQuadsumRetryAdRequired(4), isFalse);
    });

    test('second failure exhausts free attempts and requires rewarded ad', () async {
      final provider = ProgressProvider();

      // Word Search 1st & 2nd fail
      await provider.failLevel(1, 60);
      await provider.failLevel(1, 60);
      expect(provider.remainingFreeAttempts(1), 0);
      expect(provider.isRetryAdRequired(1), isTrue);

      // Sudoku 1st & 2nd fail
      await provider.failSudokuLevel(2, 120);
      await provider.failSudokuLevel(2, 120);
      expect(provider.sudokuRemainingFreeAttempts(2), 0);
      expect(provider.isSudokuRetryAdRequired(2), isTrue);

      // Cryptogram 1st & 2nd fail
      await provider.failCryptogramLevel(3, 180);
      await provider.failCryptogramLevel(3, 180);
      expect(provider.cryptogramRemainingFreeAttempts(3), 0);
      expect(provider.isCryptogramRetryAdRequired(3), isTrue);

      // Quadsum 1st & 2nd fail
      await provider.failQuadsumLevel(4, 150);
      await provider.failQuadsumLevel(4, 150);
      expect(provider.quadsumRemainingFreeAttempts(4), 0);
      expect(provider.isQuadsumRetryAdRequired(4), isTrue);
    });

    test('completing level clears fail count and restores 2 free attempts', () async {
      final provider = ProgressProvider();

      await provider.failQuadsumLevel(1, 60);
      await provider.failQuadsumLevel(1, 60);
      expect(provider.isQuadsumRetryAdRequired(1), isTrue);

      await provider.completeQuadsumLevel(1, 40);
      expect(provider.isQuadsumRetryAdRequired(1), isFalse);
      expect(provider.quadsumRemainingFreeAttempts(1), 2);
    });

    test('failed attempt counts persist across load()', () async {
      final provider1 = ProgressProvider();
      await provider1.failLevel(3, 60);
      await provider1.failLevel(3, 60);
      await provider1.failSudokuLevel(7, 120);
      await provider1.failCryptogramLevel(9, 150);
      await provider1.failCryptogramLevel(9, 150);
      await provider1.failQuadsumLevel(5, 140);
      await provider1.failQuadsumLevel(5, 140);

      final provider2 = ProgressProvider();
      await provider2.load();

      expect(provider2.isRetryAdRequired(3), isTrue);
      expect(provider2.remainingFreeAttempts(3), 0);

      expect(provider2.isSudokuRetryAdRequired(7), isFalse);
      expect(provider2.sudokuRemainingFreeAttempts(7), 1);

      expect(provider2.isCryptogramRetryAdRequired(9), isTrue);
      expect(provider2.cryptogramRemainingFreeAttempts(9), 0);

      expect(provider2.isQuadsumRetryAdRequired(5), isTrue);
      expect(provider2.quadsumRemainingFreeAttempts(5), 0);
    });

    test('resetProgress clears all failed attempt counts', () async {
      final provider = ProgressProvider();
      await provider.failLevel(3, 60);
      await provider.failLevel(3, 60);
      await provider.failSudokuLevel(7, 120);
      await provider.failCryptogramLevel(9, 150);
      await provider.failCryptogramLevel(9, 150);
      await provider.failQuadsumLevel(5, 140);
      await provider.failQuadsumLevel(5, 140);

      await provider.resetProgress();

      expect(provider.isRetryAdRequired(3), isFalse);
      expect(provider.remainingFreeAttempts(3), 2);
      expect(provider.isSudokuRetryAdRequired(7), isFalse);
      expect(provider.sudokuRemainingFreeAttempts(7), 2);
      expect(provider.isCryptogramRetryAdRequired(9), isFalse);
      expect(provider.cryptogramRemainingFreeAttempts(9), 2);
      expect(provider.isQuadsumRetryAdRequired(5), isFalse);
      expect(provider.quadsumRemainingFreeAttempts(5), 2);
    });
  });
}
