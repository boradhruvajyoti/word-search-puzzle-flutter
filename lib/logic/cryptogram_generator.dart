// Logic: CryptogramGenerator — seed-based substitution cipher generator for Cryptograms
import 'dart:math';

class CryptogramPuzzle {
  final String quote;
  final String cipherText;
  final String author;
  final String category;
  final Map<String, String> cipherToPlain;
  final Map<String, String> plainToCipher;
  final Set<String> initialRevealed;

  const CryptogramPuzzle({
    required this.quote,
    required this.cipherText,
    required this.author,
    required this.category,
    required this.cipherToPlain,
    required this.plainToCipher,
    required this.initialRevealed,
  });
}

class CryptogramGenerator {
  CryptogramGenerator._();

  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Generates a [CryptogramPuzzle] deterministically using the level seed.
  static CryptogramPuzzle generate({
    required String rawQuote,
    required String author,
    required String category,
    required int level,
    required int initialHints,
  }) {
    final quoteUpper = rawQuote.toUpperCase();
    final random = Random(level * 37 + 1013);

    // Collect all distinct letters in the quote
    final distinctLetters = <String>{};
    for (int i = 0; i < quoteUpper.length; i++) {
      final char = quoteUpper[i];
      if (_alphabet.contains(char)) {
        distinctLetters.add(char);
      }
    }

    // Generate a derangement permutation of A-Z
    final plainToCipher = <String, String>{};
    final cipherToPlain = <String, String>{};

    final lettersList = _alphabet.split('');
    List<String> shuffled;
    int attempts = 0;
    do {
      shuffled = List<String>.from(lettersList)..shuffle(random);
      attempts++;
    } while (_hasFixedPointForPresent(lettersList, shuffled, distinctLetters) && attempts < 100);

    // Guarantee derangement for distinct letters
    for (int i = 0; i < lettersList.length; i++) {
      if (lettersList[i] == shuffled[i]) {
        // Swap with next element
        final swapIdx = (i + 1) % lettersList.length;
        final temp = shuffled[i];
        shuffled[i] = shuffled[swapIdx];
        shuffled[swapIdx] = temp;
      }
    }

    for (int i = 0; i < lettersList.length; i++) {
      plainToCipher[lettersList[i]] = shuffled[i];
      cipherToPlain[shuffled[i]] = lettersList[i];
    }

    // Construct cipherText
    final buffer = StringBuffer();
    for (int i = 0; i < quoteUpper.length; i++) {
      final char = quoteUpper[i];
      if (plainToCipher.containsKey(char)) {
        buffer.write(plainToCipher[char]);
      } else {
        buffer.write(char);
      }
    }
    final cipherText = buffer.toString();

    // Select initial hints from distinct letters present in quote
    final initialRevealed = <String>{};
    if (initialHints > 0 && distinctLetters.isNotEmpty) {
      final presentList = distinctLetters.toList()..shuffle(random);
      final count = min(initialHints, presentList.length);
      for (int i = 0; i < count; i++) {
        initialRevealed.add(presentList[i]);
      }
    }

    return CryptogramPuzzle(
      quote: rawQuote,
      cipherText: cipherText,
      author: author,
      category: category,
      cipherToPlain: cipherToPlain,
      plainToCipher: plainToCipher,
      initialRevealed: initialRevealed,
    );
  }

  static bool _hasFixedPointForPresent(
    List<String> original,
    List<String> shuffled,
    Set<String> present,
  ) {
    for (int i = 0; i < original.length; i++) {
      if (present.contains(original[i]) && original[i] == shuffled[i]) {
        return true;
      }
    }
    return false;
  }
}
