// Unit tests: WordDictionary & WordBank multi-category pulling
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/word_bank.dart';
import 'package:word_search_puzzle/logic/word_dictionary.dart';

void main() {
  group('WordBank.randomWordsForSize', () {
    test('pulls random words fitting max length', () {
      final words = WordBank.randomWordsForSize(5);
      expect(words.isNotEmpty, true);
      for (final w in words) {
        expect(w.length <= 5, true);
        expect(w.length >= 3, true);
      }
    });
  });

  group('WordDictionary.getDefinition', () {
    test('returns curated definition for known words', () {
      final lionDef = WordDictionary.getDefinition('LION');
      expect(lionDef, contains('cat that lives in prides'));

      final appleDef = WordDictionary.getDefinition('APPLE');
      expect(appleDef, contains('apple trees'));
    });

    test('returns automatic category definition for any word in WordBank', () {
      final albatrossDef = WordDictionary.getDefinition('ALBATROSS');
      expect(albatrossDef.isNotEmpty, true);

      final tokyoDef = WordDictionary.getDefinition('TOKYO');
      expect(tokyoDef.isNotEmpty, true);
    });

    test('getCategoryForWord returns category name', () {
      final category = WordDictionary.getCategoryForWord('LION');
      expect(category.toLowerCase(), contains('animal'));
    });

    test('is case insensitive', () {
      final defLower = WordDictionary.getDefinition('tiger');
      final defUpper = WordDictionary.getDefinition('TIGER');
      expect(defLower, equals(defUpper));
    });
  });
}
