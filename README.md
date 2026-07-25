# Word Search Puzzle 🔤

A production-ready, multi-level word search puzzle game built with **Flutter** for Android and iOS.

---

## Features

- 🔠 Square letter grids scaling from 5×5 to 15×15
- 🧭 Words placed in 8 directions (horizontal, vertical, all diagonals — forward & reverse)
- 👆 Live swipe gesture with highlight path rendered via `CustomPainter`
- 🎨 Found words marked with colored strikethrough in both grid and word list
- ⏱ Countdown timer with warning color changes
- 🏆 Star rating (1–3) based on time remaining
- 📈 30+ levels with formula-based difficulty scaling
- 💾 Progress persistence via `shared_preferences`
- 🌙 Light/Dark mode toggle
- 📱 Responsive layout for phones and tablets

---

## Folder Structure

```
lib/
├── main.dart                    # App entry point, Provider setup
├── models/
│   ├── cell.dart                # Grid cell model
│   ├── word_entry.dart          # Word placement model + direction constants
│   ├── level_config.dart        # Level configuration data class
│   └── game_state.dart          # GameStatus enum
├── logic/
│   ├── word_bank.dart           # Curated word bank (6 categories, 200+ words)
│   ├── grid_generator.dart      # Pure Dart: word placement + random fill
│   ├── word_validator.dart      # Pure Dart: swipe validation, win detection
│   └── level_manager.dart       # Formula-based level config + star rating
├── providers/
│   ├── game_provider.dart       # Game state: grid, timer, swipe, found words
│   └── progress_provider.dart   # Persistent: levels, best times, settings
├── screens/
│   ├── home_screen.dart         # Landing screen with animated logo
│   ├── level_select_screen.dart # Grid of 30 level tiles
│   ├── game_screen.dart         # Main game: grid + word list + timer
│   ├── level_complete_screen.dart # Stars, time, next level
│   ├── game_over_screen.dart    # Time's up + retry
│   └── settings_screen.dart     # Dark mode, sound, reset progress
├── widgets/
│   ├── grid_painter.dart        # CustomPainter for swipe + found-word lines
│   ├── grid_widget.dart         # GestureDetector + grid + painter stack
│   ├── word_list_panel.dart     # Word chips with animated strikethrough
│   ├── timer_bar.dart           # Animated countdown progress bar
│   ├── level_tile.dart          # Level card (locked/unlocked, best time)
│   └── star_rating.dart         # Animated 1-3 star display
└── utils/
    ├── constants.dart           # Sizes, durations, SharedPrefs keys, colors
    ├── app_theme.dart           # Light & dark ThemeData (Google Fonts: Outfit)
    └── extensions.dart          # String, Color, Duration extensions

test/
├── grid_generator_test.dart     # Grid generation unit tests
├── word_validator_test.dart     # Swipe validation unit tests
└── level_manager_test.dart      # Level formula unit tests
```

---

## How to Run

```bash
# Install dependencies
flutter pub get

# Run on connected device / simulator
flutter run

# Run all unit tests
flutter test
```

---

## Level Difficulty Scaling

Levels scale automatically using this formula:

| Parameter | Formula | Cap |
|-----------|---------|-----|
| Grid Size | `4 + level` | max 15×15 |
| Word Count | `4 + level` | max 20 words |
| Time Limit | `45 + level × 15` seconds | no cap |

Example progression:

| Level | Grid | Words | Time |
|-------|------|-------|------|
| 1 | 5×5 | 5 | 60s |
| 5 | 9×9 | 9 | 120s |
| 10 | 14×14 | 14 | 195s |
| 12+ | 15×15 | 16+ | 225s+ |

---

## Word Bank

The game includes **200+ curated words** across 6 categories, cycling per level:

| Level | Category |
|-------|----------|
| 1 | Animals |
| 2 | Fruits |
| 3 | Countries |
| 4 | Sports |
| 5 | Colors |
| 6 | Nature |
| 7+ | Repeats cycle |

### Adding New Words

Edit `lib/logic/word_bank.dart` and add words to any category list:

```dart
'animals': [
  // Add your words here — ALL CAPS, length 3–15
  'PLATYPUS',
  ...
],
```

Words are automatically filtered to fit the current grid size (length ≤ gridSize).

---

## Tech Stack

- **Flutter** 3.44+ / **Dart** 3.12+
- **Provider** — state management
- **shared_preferences** — persistent storage
- **Google Fonts** (Outfit) — typography

---

## Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires Xcode + provisioning)
flutter build ios --release
```

---

## Bundle ID

`com.wordsearch.word_search_puzzle`
