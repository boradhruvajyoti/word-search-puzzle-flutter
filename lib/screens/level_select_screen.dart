// Screens: LevelSelectScreen — grid of level tiles
import 'package:flutter/material.dart';
import '../widgets/level_tile.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  static const int totalLevelsToShow = 30;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: totalLevelsToShow,
          itemBuilder: (context, index) {
            final level = index + 1;
            return LevelTile(
              level: level,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(level: level),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
