// Widget tests for Word Search Puzzle
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:word_search_puzzle/main.dart';
import 'package:word_search_puzzle/providers/cryptogram_game_provider.dart';
import 'package:word_search_puzzle/providers/game_provider.dart';
import 'package:word_search_puzzle/providers/progress_provider.dart';
import 'package:word_search_puzzle/providers/quadsum_game_provider.dart';
import 'package:word_search_puzzle/providers/sudoku_game_provider.dart';

void main() {
  testWidgets('App renders HomeScreen with all 4 2-column game cards', (WidgetTester tester) async {
    final progressProvider = ProgressProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: progressProvider),
          ChangeNotifierProvider(create: (_) => GameProvider()),
          ChangeNotifierProvider(create: (_) => SudokuGameProvider()),
          ChangeNotifierProvider(create: (_) => CryptogramGameProvider()),
          ChangeNotifierProvider(create: (_) => QuadsumGameProvider()),
        ],
        child: const WordSearchApp(),
      ),
    );

    // HomeScreen should show 2-column game cards
    expect(find.text('Word Search'), findsAtLeastNWidgets(1));
    expect(find.text('Sudoku'), findsAtLeastNWidgets(1));
    expect(find.text('Cryptogram'), findsAtLeastNWidgets(1));
    expect(find.text('Quadsum'), findsAtLeastNWidgets(1));
  });
}
