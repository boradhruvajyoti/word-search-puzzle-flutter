// Unit tests: AppLanguage & Multi-language WordBank
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/models/app_language.dart';
import 'package:word_search_puzzle/logic/word_bank.dart';

void main() {
  group('AppLanguage metadata', () {
    test('has exactly 20 supported languages', () {
      expect(AppLanguage.languages.length, 20);
    });

    test('languages are sorted in alphabetical order by English name', () {
      final names = AppLanguage.languages.map((l) => l.name).toList();
      final sortedNames = List<String>.from(names)..sort();
      expect(names, equals(sortedNames));
    });

    test('fromCode returns correct AppLanguage or defaults to English', () {
      expect(AppLanguage.fromCode('hi').name, 'Hindi');
      expect(AppLanguage.fromCode('es').name, 'Spanish');
      expect(AppLanguage.fromCode('as').name, 'Assamese');
      expect(AppLanguage.fromCode('unknown').code, 'en');
    });
  });

  group('WordBank multi-language word fetching', () {
    test('print exact word count per language', () {
      for (final lang in AppLanguage.languages) {
        if (lang.code == 'en') {
          final words = WordBank.randomWordsForLanguage(10, 'en');
          print('COUNT | ${lang.name} (en): ${words.length} filtered (10,000+ total in categories)');
        } else {
          final list = WordBank.multiLangBank[lang.code] ?? [];
          print('COUNT | ${lang.name} (${lang.code}): ${list.length} words');
        }
      }
    });

    for (final lang in AppLanguage.languages) {
      test('fetches valid words for language: ${lang.name} (${lang.code})', () {
        final words = WordBank.randomWordsForLanguage(8, lang.code);
        expect(words.isNotEmpty, true);
      });
    }
  });
}
