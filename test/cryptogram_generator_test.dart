// Unit tests: CryptogramGenerator
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/logic/cryptogram_generator.dart';

void main() {
  group('CryptogramGenerator.generate', () {
    test('generates valid substitution cipher preserving punctuation and spacing', () {
      final puzzle = CryptogramGenerator.generate(
        rawQuote: 'Hello, World! Life is 100% amazing.',
        author: 'Unknown',
        category: 'Life',
        level: 1,
        initialHints: 2,
      );

      expect(puzzle.quote, 'Hello, World! Life is 100% amazing.');
      expect(puzzle.cipherText.length, puzzle.quote.length);

      // Check punctuation is preserved
      expect(puzzle.cipherText[5], ',');
      expect(puzzle.cipherText[6], ' ');
      expect(puzzle.cipherText[12], '!');
      expect(puzzle.cipherText[13], ' ');

      // Check derangement: no mapped letter maps to itself
      for (final entry in puzzle.plainToCipher.entries) {
        if (puzzle.quote.toUpperCase().contains(entry.key)) {
          expect(entry.key, isNot(equals(entry.value)));
        }
      }

      // Check initial hints
      expect(puzzle.initialRevealed.length, 2);
    });

    test('deterministic generation for same level', () {
      final p1 = CryptogramGenerator.generate(
        rawQuote: 'Curiosity is the key.',
        author: 'Einstein',
        category: 'Science',
        level: 42,
        initialHints: 1,
      );

      final p2 = CryptogramGenerator.generate(
        rawQuote: 'Curiosity is the key.',
        author: 'Einstein',
        category: 'Science',
        level: 42,
        initialHints: 1,
      );

      expect(p1.cipherText, p2.cipherText);
      expect(p1.initialRevealed, p2.initialRevealed);
    });
  });
}
