// App entry point — sets up Provider tree, theme, and routing
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'logic/ad_helper.dart';
import 'providers/game_provider.dart';
import 'providers/sudoku_game_provider.dart';
import 'providers/cryptogram_game_provider.dart';
import 'providers/quadsum_game_provider.dart';
import 'providers/progress_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads SDK and start preloading ads
  try {
    await AdHelper.init();
  } catch (e) {
    debugPrint('Failed to initialize AdHelper: $e');
  }

  // Lock to portrait
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrint('Failed to set preferred orientations: $e');
  }

  final progressProvider = ProgressProvider();
  try {
    await progressProvider.load();
  } catch (e) {
    debugPrint('Failed to load progress provider: $e');
  }

  runApp(
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
}

class WordSearchApp extends StatelessWidget {
  const WordSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return MaterialApp(
      title: 'Classic Puzzle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: progress.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
