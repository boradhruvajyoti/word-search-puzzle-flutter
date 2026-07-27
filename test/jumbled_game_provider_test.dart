// Tests: JumbledGameProvider unit tests
import 'package:flutter_test/flutter_test.dart';
import 'package:word_search_puzzle/models/game_state.dart';
import 'package:word_search_puzzle/providers/jumbled_game_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JumbledGameProvider Tests', () {
    late JumbledGameProvider provider;

    setUp(() {
      provider = JumbledGameProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    test('Initial state is idle', () {
      expect(provider.status, equals(GameStatus.idle));
      expect(provider.targetWords, isEmpty);
    });

    test('startLevel initializes game state', () {
      provider.startLevel(1, 'en');

      expect(provider.status, equals(GameStatus.playing));
      expect(provider.config, isNotNull);
      expect(provider.targetWords.length, equals(1));
      expect(provider.scrambledLetters.isNotEmpty, isTrue);
      expect(provider.userPlacedChars.length, equals(provider.activeTargetChars.length));
    });

    test('Tapping letter tile places character in slots', () {
      provider.startLevel(1, 'en');

      expect(provider.userPlacedChars.first, isNull);
      provider.tapTile(0);

      expect(provider.userPlacedChars.first, equals(provider.scrambledLetters[0]));
      expect(provider.usedTileIndices.contains(0), isTrue);
    });

    test('Removing placed char frees tile', () {
      provider.startLevel(1, 'en');
      provider.tapTile(0);

      provider.removePlacedChar(0);
      expect(provider.userPlacedChars.first, isNull);
      expect(provider.usedTileIndices.contains(0), isFalse);
    });

    test('Clear all resets placed chars for current word', () {
      provider.startLevel(1, 'en');
      provider.tapTile(0);
      provider.clearAll();

      expect(provider.userPlacedChars.every((c) => c == null), isTrue);
      expect(provider.usedTileIndices, isEmpty);
    });

    test('Hint places correct character in target slot', () {
      provider.startLevel(1, 'en');
      provider.useHint();

      expect(provider.userPlacedChars.first, equals(provider.activeTargetChars.first));
    });
  });
}
