// Logic: Word bank — curated words by category, all uppercase
class WordBank {
  static const Map<String, List<String>> categories = {
    'animals': [
      'LION', 'TIGER', 'BEAR', 'WOLF', 'DEER', 'FROG', 'CROW', 'EAGLE',
      'SHARK', 'WHALE', 'HORSE', 'ZEBRA', 'PANDA', 'KOALA', 'CAMEL',
      'SNAKE', 'GECKO', 'PARROT', 'ROBIN', 'CRANE', 'OTTER', 'MOOSE',
      'BISON', 'HYENA', 'LLAMA', 'RHINO', 'HIPPO', 'CHIMP', 'VIPER',
      'RAVEN', 'FALCON', 'JAGUAR', 'COUGAR', 'DONKEY', 'RABBIT', 'MONKEY',
      'TURTLE', 'LIZARD', 'SALMON', 'TOUCAN', 'PELICAN', 'LEOPARD',
      'PANTHER', 'GORILLA', 'BUFFALO', 'GIRAFFE', 'GAZELLE', 'SPARROW',
      'PENGUIN', 'DOLPHIN', 'LOBSTER', 'OCTOPUS', 'HAMSTER', 'CHEETAH',
    ],
    'fruits': [
      'APPLE', 'MANGO', 'GRAPE', 'PEACH', 'PLUM', 'PEAR', 'LIME',
      'KIWI', 'DATE', 'FIG', 'BERRY', 'GUAVA', 'LEMON', 'MELON',
      'PAPAYA', 'CHERRY', 'LYCHEE', 'BANANA', 'ORANGE', 'POMELO',
      'APRICOT', 'AVOCADO', 'COCONUT', 'PASSION', 'QUINCE', 'MANGO',
      'TOMATO', 'JACKFRUIT', 'TAMARIND', 'STARFRUIT',
    ],
    'countries': [
      'INDIA', 'CHINA', 'JAPAN', 'ITALY', 'SPAIN', 'EGYPT', 'GHANA',
      'KENYA', 'PERU', 'CUBA', 'IRAN', 'IRAQ', 'OMAN', 'FIJI',
      'NEPAL', 'CHILE', 'LAOS', 'MALI', 'TOGO', 'CHAD', 'NIGER',
      'FRANCE', 'GREECE', 'BRAZIL', 'RUSSIA', 'MEXICO', 'TURKEY',
      'POLAND', 'CANADA', 'SWEDEN', 'NORWAY', 'ISRAEL', 'JORDAN',
      'KUWAIT', 'BHUTAN', 'TAIWAN', 'VIETNAM', 'UKRAINE', 'CROATIA',
      'DENMARK', 'AUSTRIA', 'BELGIUM', 'HUNGARY', 'ICELAND', 'IRELAND',
      'PORTUGAL', 'COLOMBIA', 'THAILAND', 'MALAYSIA', 'ETHIOPIA',
    ],
    'sports': [
      'GOLF', 'POLO', 'SWIM', 'YOGA', 'SURF', 'DIVE', 'JUDO',
      'RUGBY', 'CHESS', 'TRACK', 'BOXING', 'HOCKEY', 'TENNIS',
      'SOCCER', 'SQUASH', 'ROWING', 'KARATE', 'SKIING', 'CYCLING',
      'ARCHERY', 'CRICKET', 'BOWLING', 'SAILING', 'FENCING', 'RUNNING',
      'SKATING', 'SHOOTING', 'SWIMMING', 'CLIMBING', 'TRIATHLON',
      'BASEBALL', 'FOOTBALL', 'HANDBALL', 'SOFTBALL', 'LACROSSE',
      'WRESTLING', 'BADMINTON', 'VOLLEYBALL', 'BASKETBALL', 'GYMNASTICS',
    ],
    'colors': [
      'RED', 'BLUE', 'GOLD', 'PINK', 'CYAN', 'TEAL', 'LIME',
      'GRAY', 'NAVY', 'PLUM', 'JADE', 'ROSE', 'RUBY', 'SAGE',
      'GREEN', 'BLACK', 'WHITE', 'AMBER', 'BEIGE', 'BROWN',
      'CORAL', 'CREAM', 'KHAKI', 'LILAC', 'MAUVE', 'OLIVE',
      'PEACH', 'TAUPE', 'AZURE', 'IVORY', 'SILVER', 'VIOLET',
      'ORANGE', 'YELLOW', 'PURPLE', 'INDIGO', 'MAROON', 'SCARLET',
      'MAGENTA', 'CRIMSON', 'EMERALD', 'FUCHSIA', 'LAVENDER', 'TURQUOISE',
    ],
    'nature': [
      'ROCK', 'LAKE', 'REEF', 'CAVE', 'DUNE', 'GULF', 'ISLE',
      'MESA', 'MOOR', 'PEAK', 'POND', 'POOL', 'VALE',
      'RIVER', 'OCEAN', 'CLOUD', 'STORM', 'FLOOD', 'CLIFF',
      'DELTA', 'FJORD', 'MARSH', 'RIDGE', 'SWAMP', 'TUNDRA',
      'FOREST', 'DESERT', 'GLACIER', 'PLATEAU', 'VOLCANO', 'WATERFALL',
      'CANYON', 'MEADOW', 'SPRING', 'STREAM', 'VALLEY', 'ISLAND',
      'JUNGLE', 'SAVANNA', 'WETLAND',
    ],
  };

  static const List<String> categoryNames = [
    'animals', 'fruits', 'countries', 'sports', 'colors', 'nature'
  ];

  /// Returns all words fitting within [maxLength], shuffled.
  static List<String> wordsForSize(int maxLength, String category) {
    final list = (categories[category] ?? categories['animals']!)
        .where((w) => w.length <= maxLength && w.length >= 3)
        .toList();
    list.shuffle();
    return list;
  }

  /// Category name for a given level (cycles through categories).
  static String categoryForLevel(int level) {
    return categoryNames[(level - 1) % categoryNames.length];
  }
}
