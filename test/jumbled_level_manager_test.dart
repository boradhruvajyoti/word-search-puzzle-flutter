// Tests: JumbledLevelManager unit tests
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/jumbled_level_manager.dart';
import 'package:word_search_puzzle/models/app_language.dart';

void main() {
  group('JumbledLevelManager Tests', () {
    test('Generates valid config for Level 1 in English', () {
      final config = JumbledLevelManager.configForLevel(1, 'en');
      expect(config.level, equals(1));
      expect(config.targetWords.length, equals(1));
      expect(config.timeLimit, equals(60));
      expect(config.targetWords.first.isNotEmpty, isTrue);
    });

    test('Generates config for 1,000 levels across languages', () {
      for (final lang in AppLanguage.languages) {
        final configLevel1 = JumbledLevelManager.configForLevel(1, lang.code);
        final configLevel500 = JumbledLevelManager.configForLevel(500, lang.code);
        final configLevel1000 = JumbledLevelManager.configForLevel(1000, lang.code);

        expect(configLevel1.targetWords.isNotEmpty, isTrue);
        expect(configLevel500.targetWords.length, equals(3));
        expect(configLevel1000.targetWords.length, equals(5));
      }
    });

    test('scrambleWord scrambles characters properly', () {
      const word = 'PUZZLE';
      final scrambled = JumbledLevelManager.scrambleWord(word);
      expect(scrambled.length, equals(word.length));
      expect(scrambled.join(''), isNot(equals(word)));
    });

    test('starsEarned calculates stars based on ratio', () {
      expect(JumbledLevelManager.starsEarned(40, 60), equals(3)); // 66% => 3 stars
      expect(JumbledLevelManager.starsEarned(20, 60), equals(2)); // 33% => 2 stars
      expect(JumbledLevelManager.starsEarned(5, 60), equals(1));  // <30% => 1 star
    });
  });
}
