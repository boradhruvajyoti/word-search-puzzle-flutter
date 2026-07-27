// Widget tests for Word Search Puzzle
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:word_search_puzzle/main.dart';
import 'package:word_search_puzzle/providers/game_provider.dart';
import 'package:word_search_puzzle/providers/jumbled_game_provider.dart';
import 'package:word_search_puzzle/providers/progress_provider.dart';

void main() {
  testWidgets('App renders HomeScreen', (WidgetTester tester) async {
    final progressProvider = ProgressProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: progressProvider),
          ChangeNotifierProvider(create: (_) => GameProvider()),
          ChangeNotifierProvider(create: (_) => JumbledGameProvider()),
        ],
        child: const WordSearchApp(),
      ),
    );

    // HomeScreen should show 'Word Search' and 'Jumbled Words' sections
    expect(find.text('Word Search'), findsAtLeastNWidgets(1));
    expect(find.text('Jumbled Words'), findsAtLeastNWidgets(1));
  });
}
