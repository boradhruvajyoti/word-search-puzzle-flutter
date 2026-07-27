// Logic: WordDictionary — educational definitions for all words in WordBank
import 'word_bank.dart';

class WordDictionary {
  static Map<String, String>? _wordToCategoryMap;

  /// Builds a reverse map from uppercase word -> category key for all words in WordBank.categories.
  static void _ensureMapInitialized() {
    if (_wordToCategoryMap != null) return;
    final map = <String, String>{};
    for (final entry in WordBank.categories.entries) {
      final categoryKey = entry.key;
      for (final word in entry.value) {
        final clean = word.trim().toUpperCase();
        if (clean.isNotEmpty && !map.containsKey(clean)) {
          map[clean] = categoryKey;
        }
      }
    }
    _wordToCategoryMap = map;
  }

  static const Map<String, String> _customDefinitions = {
    // Animals
    'LION': 'A large tawny-colored cat that lives in prides, native to Africa and India.',
    'TIGER': 'The largest living cat species, known for its dark vertical stripes on orange fur.',
    'BEAR': 'A large, heavy mammal with thick fur and short legs, native to various habitats worldwide.',
    'WOLF': 'A wild carnivorous mammal of the dog family, living and hunting in packs.',
    'EAGLE': 'A large bird of prey with a massive hooked beak and keen eyesight.',
    'SHARK': 'A long-bodied marine fish with a cartilaginous skeleton and prominent dorsal fin.',
    'WHALE': 'A very large marine mammal with a streamlined body and blowhole for breathing.',
    'ZEBRA': 'An African wild horse with distinctive black-and-white striped coats.',
    'PANDA': 'A large bear-like mammal native to China, famous for its black-and-white markings and bamboo diet.',
    'KOALA': 'An Australian tree-dwelling marsupial with gray fur and big round ears, feeding on eucalyptus leaves.',
    'CAMEL': 'A large desert mammal with one or two humps on its back used to store fat.',
    'SNAKE': 'A long, legless reptile that moves by slithering along the ground.',
    'DOLPHIN': 'A highly intelligent marine mammal known for its playful behavior and echo-location ability.',
    'PENGUIN': 'A flightless seabird that lives in the Southern Hemisphere, adapted for swimming.',
    'CHEETAH': 'The fastest land animal on Earth, capable of reaching speeds up to 70 mph.',
    'ELEPHANT': 'The largest living land animal, recognized by its trunk and large ears.',
    'GIRAFFE': 'The tallest living terrestrial animal, famous for its extremely long neck and spotted pattern.',
    'KANGAROO': 'An Australian marsupial with strong hind legs adapted for hopping.',
    'OCTOPUS': 'A soft-bodied, eight-armed marine mollusk known for its high intelligence and ink projection.',

    // Birds
    'OWL': 'A nocturnal bird of prey with large forward-facing eyes and silent flight.',
    'HAWK': 'A medium-sized bird of prey known for its sharp eyesight and swift hunting dives.',
    'SWAN': 'A large waterbird with a long flexible neck and beautiful white plumage.',
    'ROBIN': 'A small songbird with a distinctive reddish-orange breast.',
    'PARROT': 'A colorful bird known for its curved beak, bright feathers, and ability to mimic human sounds.',

    // Fruits
    'APPLE': 'A sweet fruit that grows on apple trees and comes in red, green, and yellow varieties.',
    'MANGO': 'A juicy tropical stone fruit with sweet yellow-orange flesh, often called the king of fruits.',
    'GRAPE': 'A small, round, smooth-skinned fruit growing in bunches, used to eat fresh or make wine.',
    'BANANA': 'A long curved fruit with a yellow skin and soft sweet flesh inside.',
    'ORANGE': 'A round citrus fruit with a tough bright orange rind and juicy sweet-sour pulp.',
    'CHERRY': 'A small, round stone fruit that is typically bright red or dark red.',

    // Vegetables
    'CARROT': 'An orange root vegetable that is crisp and rich in vitamin A.',
    'BROCCOLI': 'A green vegetable with large flowering heads eaten raw or cooked.',
    'SPINACH': 'A leafy green vegetable packed with iron and nutritional vitamins.',
    'POTATO': 'A starchy tuberous crop that is a staple food in many cultures worldwide.',
    'TOMATO': 'A red juicy fruit cooked as a vegetable, essential in sauces and salads.',

    // Countries & Cities
    'INDIA': 'A South Asian country with diverse terrain, rich history, and culture.',
    'JAPAN': 'An island nation in East Asia famous for its traditions, technology, and cuisine.',
    'FRANCE': 'A Western European country renowned for its art, fashion, gastronomy, and landmarks.',
    'EGYPT': 'A country in North Africa famous for its ancient pyramids, Sphinx, and the Nile River.',
    'BRAZIL': 'The largest country in South America, famous for the Amazon rainforest and football.',
    'PARIS': 'The capital city of France, famous as the City of Light.',
    'TOKYO': 'The bustling capital of Japan, blending ultramodern skyscrapers with historic temples.',
    'ROME': 'The historic capital city of Italy, home to the ancient Colosseum and Vatican City.',

    // Science & Tech
    'ATOM': 'The basic building block of all chemical elements and matter.',
    'GENE': 'A unit of heredity passed from parent to offspring that determines traits.',
    'ORBIT': 'The curved path of a celestial object or spacecraft around a star or planet.',
    'LASER': 'A device that emits a narrow, focused beam of coherent light.',
    'VIRUS': 'A microscopic infectious agent that replicates inside living cells.',
    'CODE': 'Instructions written in a programming language to instruct computers.',
    'DATA': 'Quantities, characters, or symbols on which operations are performed by a computer.',
    'SERVER': 'A computer program or device that provides services or data to other computers.',
    'PIXEL': 'The smallest unit of a digital image or display screen.',
    'ROBOT': 'A machine capable of carrying out a complex series of actions automatically.',

    // Space
    'MARS': 'The fourth planet from the Sun, often called the Red Planet due to iron oxide on its surface.',
    'COMET': 'A small icy body that releases gas forming a visible tail when passing near the Sun.',
    'NEBULA': 'A giant cloud of dust and gas in space, often a region where new stars are born.',
    'GALAXY': 'A massive system of millions or billions of stars, gas, and dust held by gravity.',
    'SATURN': 'The sixth planet from the Sun, famous for its extensive system of bright planetary rings.',

    // Sports & Music
    'SOCCER': 'A team sport played with a spherical ball between two teams of 11 players.',
    'CHESS': 'A two-player strategy board game played on an 8x8 checkered board.',
    'TENNIS': 'A racket sport played individually against an opponent or in pairs.',
    'JAZZ': 'A genre of music characterized by swing notes, blue notes, and improvisation.',
    'PIANO': 'A large keyboard musical instrument that produces sound when hammers strike strings.',
    'GUITAR': 'A stringed musical instrument played by plucking or strumming strings.',

    // Weather & Nature
    'STORM': 'A violent disturbance of the atmosphere with strong winds and rain or thunder.',
    'DESERT': 'A dry, barren area of land with little precipitation and sparse vegetation.',
    'VOLCANO': 'A mountain having a crater through which lava, rock fragments, and gas erupt.',
    'OCEAN': 'A vast body of salt water that covers almost three-quarters of the Earth’s surface.',
  };

  /// Returns the educational definition for ANY word in WordBank (10,000+ words).
  static String getDefinition(String word, [String? fallbackCategoryKey]) {
    final uppercaseWord = word.trim().toUpperCase();
    if (_customDefinitions.containsKey(uppercaseWord)) {
      return _customDefinitions[uppercaseWord]!;
    }

    _ensureMapInitialized();
    final categoryKey = _wordToCategoryMap![uppercaseWord] ?? fallbackCategoryKey ?? 'general';
    final categoryName = WordBank.categoryDisplayNames[categoryKey] ?? categoryKey;

    switch (categoryKey) {
      case 'animals':
        return '$uppercaseWord is a species of animal or wildlife native to natural habitats.';
      case 'birds':
        return '$uppercaseWord is a species of bird known for its plumage and flight.';
      case 'sea_life':
        return '$uppercaseWord is an aquatic creature or marine species inhabiting ocean waters.';
      case 'insects':
        return '$uppercaseWord is a small arthropod insect with a segmented body and legs.';
      case 'fruits':
        return '$uppercaseWord is a sweet or tart edible fruit packed with vitamins and natural sugars.';
      case 'vegetables':
        return '$uppercaseWord is a nutritious plant or root vegetable cultivated for food.';
      case 'countries':
        return '$uppercaseWord is a sovereign country and geopolitical nation located on Earth.';
      case 'cities':
        return '$uppercaseWord is a major city and urban municipality with economic significance.';
      case 'sports':
        return '$uppercaseWord is a competitive athletic sport, physical activity, or game of skill.';
      case 'colors':
        return '$uppercaseWord is a distinct color shade, hue, or pigment on the visual spectrum.';
      case 'food':
        return '$uppercaseWord is a delicious dish, culinary ingredient, or beverage enjoyed around the world.';
      case 'science':
        return '$uppercaseWord is a fundamental scientific term, chemical element, or natural law.';
      case 'technology':
        return '$uppercaseWord is a digital technology term, computing concept, or modern software tool.';
      case 'music':
        return '$uppercaseWord is a musical term, instrument, rhythmic style, or composition element.';
      case 'jobs':
        return '$uppercaseWord is a professional career, occupation, or skilled trade.';
      case 'plants':
        return '$uppercaseWord is a species of plant, flower, tree, or botanical flora.';
      case 'weather':
        return '$uppercaseWord is a meteorological event, climate condition, or atmospheric phenomenon.';
      case 'space':
        return '$uppercaseWord is an astronomical object, planet, or cosmic phenomenon in space.';
      case 'mythology':
        return '$uppercaseWord is a legendary figure, deity, or mythological concept from folklore.';
      case 'health':
        return '$uppercaseWord is an anatomical organ, medical condition, or biological body term.';
      default:
        return '$uppercaseWord is a featured vocabulary word in the $categoryName category.';
    }
  }

  /// Returns the category display name for any word in WordBank.
  static String getCategoryForWord(String word) {
    final uppercaseWord = word.trim().toUpperCase();
    _ensureMapInitialized();
    final catKey = _wordToCategoryMap![uppercaseWord] ?? 'general';
    return WordBank.categoryDisplayNames[catKey] ?? catKey.toUpperCase();
  }
}
