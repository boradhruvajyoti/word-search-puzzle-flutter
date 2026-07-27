import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/models/app_language.dart';
import 'package:word_search_puzzle/logic/word_bank.dart';

void main() {
  group('AppLanguage metadata', () {
    test('has English supported language', () {
      expect(AppLanguage.languages.length, 1);
      expect(AppLanguage.languages.first.code, 'en');
    });

    test('fromCode returns English', () {
      expect(AppLanguage.fromCode('en').name, 'English');
      expect(AppLanguage.fromCode('unknown').code, 'en');
    });
  });

  group('WordBank English word fetching', () {
    test('fetches valid English words', () {
      final words = WordBank.randomWordsForLanguage(8, 'en');
      expect(words.isNotEmpty, true);
    });
  });
}
