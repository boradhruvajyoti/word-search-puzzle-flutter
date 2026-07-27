// Unit tests: WordDictionary
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/word_dictionary.dart';

void main() {
  group('WordDictionary.getDefinition', () {
    test('returns curated definition for known words', () {
      final lionDef = WordDictionary.getDefinition('LION', 'animals');
      expect(lionDef, contains('cat that lives in prides'));

      final appleDef = WordDictionary.getDefinition('APPLE', 'fruits');
      expect(appleDef, contains('apple trees'));
    });

    test('returns contextual fallback definition for unknown words', () {
      final fallbackAnim = WordDictionary.getDefinition('MYSTERYBEAST', 'animals');
      expect(fallbackAnim, contains('MYSTERYBEAST is an animal species'));

      final fallbackSpace = WordDictionary.getDefinition('NEWGALAXY', 'space');
      expect(fallbackSpace, contains('NEWGALAXY is an astronomical object'));
    });

    test('is case insensitive', () {
      final defLower = WordDictionary.getDefinition('tiger', 'animals');
      final defUpper = WordDictionary.getDefinition('TIGER', 'animals');
      expect(defLower, equals(defUpper));
    });
  });
}
