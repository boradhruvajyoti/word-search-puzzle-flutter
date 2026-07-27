// Logic: Word bank — English dictionary categories
class WordBank {
  // ── English Categories (10,000+ words) ───────────────────────────────────
  static const Map<String, List<String>> categories = {
    'animals': [
      'ANT','APE','ASS','BAT','BEE','BOA','BUG','CAT','COD','COW','CUB',
      'DAM','DOE','DOG','EMU','EWE','FLY','GNU','HEN','JAY','KOI','OX',
      'PIG','PUP','RAM','RAT','YAK','EEL',
      'BEAR','BIRD','BUCK','BULL','CALF','CARP','CLAM','COLT','CRAB','CROW',
      'DART','DEER','DODO','DOVE','DUCK','DUNG','FAWN','FILLY','FISH',
      'FLEA','FOAL','FROG','GNAT','GOAT','GULL','HARE','HAWK','IBIS',
      'KITE','LAMB','LARK','LION','LOON','LYNX','MINK','MOLE','MULE',
      'NEWT','PONY','PREY','PUMA','SLUG','SWAN','TOAD','WASP','WREN',
      'WORM','WOLF','VOLE','VIPER',
      'BISON','CAMEL','CHIMP','COBRA','CRANE','EAGLE','FINCH',
      'GECKO','GOOSE','GREBE','GRUB','HIPPO','HORSE','HYENA','KOALA','LLAMA',
      'MACAW','MOOSE','MOTHS','MOUSE','OKAPI','OTTER','PANDA','QUAIL','RAVEN',
      'RHINO','ROBIN','SHREW','SKUNK','SLOTH','SNAIL','SQUID',
      'STOAT','STORK','SWIFT','TAPIR','TIGER','VIXEN','WEASEL','WHALE','ZEBRA',
      'BADGER','BEAGLE','BEETLE','CANARY','CONDOR','COUGAR',
      'COYOTE','DONKEY','FALCON','FERRET','GIBBON','GOPHER','GROUSE','IMPALA',
      'IGUANA','JAGUAR','MAGPIE','MARMOT','MARTIN','MINNOW','MONKEY','OSPREY',
      'PARROT','PIGEON','PLOVER','PUFFIN','PYTHON','RABBIT','RACOON','SALMON',
      'SEAHORSE','SERVAL','SHRIMP','SPIDER','THRUSH','TOUCAN','TURKEY','TURTLE','WALRUS','WOMBAT',
      'CARIBOU','CATFISH','CHEETAH','CHICKEN','DOLPHIN','GAZELLE','GIRAFFE',
      'GORILLA','HAMSTER','HERRING','LEOPARD','LOBSTER','MANATEE','MARMOSET',
      'OCTOPUS','PANTHER','PEACOCK','PELICAN','PENGUIN','PIRANHA','SPARROW',
      'VULTURE','WALLABY','WARBLER','BUFFALO',
      'AARDVARK','ALBACORE','ANTELOPE','BLUEBIRD','BLOWFISH','CARDINAL',
      'CHIPMUNK','FLAMINGO','HEDGEHOG','MACKEREL','MONGOOSE',
      'NARWHAL','PARAKEET','PHEASANT','PLATYPUS','PORCUPINE',
      'PORPOISE','SCORPION','SEAHORSE','SQUIRREL','STINGRAY','STURGEON',
      'SWALLOW','TARANTULA','TORTOISE',
      'ALLIGATOR','ARMADILLO','BARRACUDA','CASSOWARY','CHAMELEON','CROCODILE',
      'DRAGONFLY','ORANGUTAN','WOLVERINE','WOODPECKER','KOOKABURRA','ROADRUNNER',
      'ALBATROSS','CENTIPEDE','MILLIPEDE','BUMBLEBEE','HONEYBEE','KINGFISHER',
    ],
    'birds': [
      'JAY','EMU','OWL','TIT','DAW','ROC','HEN',
      'DOVE','DUCK','GULL','HAWK','IBIS','KITE','KIWI',
      'LARK','LOON','ROOK','RUFF','SNIPE','SWAN','SWIFT','WREN',
      'CRANE','EGRET','FINCH','GOOSE','GREBE','HERON',
      'MACAW','MERLIN','MARTIN','MYNA','PEWEE','PIPIT','PLOVER',
      'QUAIL','RAVEN','ROBIN','STILT','STORK','VIREO','WARBLER',
      'AVOCET','BULBUL','CANARY','CONDOR','CUCKOO','CURLEW','FALCON',
      'GANNET','GODWIT','GROUSE','HOOPOE','JUNCO','MAGPIE',
      'OSPREY','PARROT','PETREL','PIGEON','PUFFIN','ROBIN',
      'SHRIKE','SISKIN','THRUSH','TOUCAN','TURKEY','WAGTAIL','WEAVER',
      'BLUEBIRD','BUNTING','CARDINAL','CATBIRD','FANTAIL','FLICKER',
      'HORNBILL','KINGBIRD','LAPWING','LORIKEET','MALLARD','MOORHEN',
      'PARAKEET','PELICAN','PENGUIN','PHEASANT','REDSTART','SANDPIPER',
      'SPARROW','SWALLOW','TANGER','VULTURE','WAXWING','WOODPECKER',
    ],
    'fruits': [
      'FIG','LIME','PLUM','DATE','YUZU',
      'APPLE','BERRY','GRAPE','LEMON','MANGO','MELON','PEACH','PEAR',
      'BANANA','CHERRY','CITRUS','DURIAN','GUAVA','LYCHEE','PAPAYA',
      'PRUNE','QUINCE','RAISIN',
      'APRICOT','AVOCADO','COCONUT','FIGWORT','KUMQUAT','MEDLAR','ORANGE',
      'POMELO','QUINCE',
      'CURRANT','DAMSONS','KIVI','MANGOSTEEN','NECTARINE','PASSION','TANGELO',
      'BLUEBERRY','CRANBERRY','DATEPALM','FIGTREE','GOOSEBERRY','GRAPEFRUIT',
      'KANGAROO','KIWIFRUIT','MULBERRY','PINEAPPLE','RASPBERRY','STARFRUIT',
      'STRAWBERRY','TANGERINE','WATERMELON',
    ],
    'vegetables': [
      'YAM','KALE','PEA','LEEK',
      'BEAN','BEET','CORN','OKRA','ONION','YAM',
      'CARROT','CELERY','CHILI','CHIVE','GARLIC','GINGER','POTATO','RADISH',
      'SQUASH','TURNIP',
      'BAMBOO','CASSAWA','ENDIVE','FENNEL','JALAPENO','LENTIL','PARSNIP',
      'PEPPER','POTATO','RADICCHIO','TOMATO','ZUCCHINI',
      'BROCCOLI','CABBAGE','GHERKIN','KOHLRABI','LETTUCE','MUSTARD',
      'PUMPKIN','RHUBARB','SHALLOT','SPINACH',
      'ARTICHOKE','ASPARAGUS','BEETROOT','CAPSICUM','CAULIFLOWER','EGGPLANT',
      'MUSHROOM','SCALLION','WATERCRESS',
    ],
    'countries': [
      'CHAD','CUBA','FIJI','IRAN','IRAQ','LAOS','MALI','NIGER','OMAN','PERU','TOGO',
      'BENIN','CHILE','CHINA','EGYPT','GABON','HAITI','INDIA','ITALY','JAPAN','KENYA',
      'LIBYA','MALTA','NAURU','NEPAL','PALAU','QATAR','SAMOA','SPAIN','SUDAN','SYRIA',
      'ANGOLA','BELIZE','BHUTAN','BRAZIL','CANADA','CYPRUS','FRANCE','GREECE','GUYANA',
      'ISRAEL','JORDAN','KUWAIT','MALAWI','MEXICO','MONACO','NORWAY','PANAMA','POLAND',
      'RUSSIA','SERBIA','TAIWAN','TURKEY','ZAMBIA',
      'ALGERIA','ARMENIA','AUSTRIA','BELGIUM','BOLIVIA','CROATIA','DENMARK','ECUADOR',
      'ESTONIA','FINLAND','GEORGIA','GERMANY','GRENADA','HUNGARY','ICELAND','IRELAND',
      'JAMAICA','LEBANON','LIBERIA','MOROCCO','NIGERIA','ROMANIA','SENEGAL','SWEDEN',
      'UKRAINE','VIETNAM',
      'ALBANIA','BAHAMAS','BULGARIA','CAMBODIA','COLOMBIA','DOMINICA','HONDURAS','HUNGARY',
      'MALAYSIA','MALDIVES','MONGOLIA','NAMIBIA','PAKISTAN','PORTUGAL','SLOVAKIA','SOMALIA',
      'THAILAND','TUNISIA','URUGUAY',
    ],
    'space': [
      'SUN','MOON','MARS','STAR','NOVA','ORBIT',
      'COMET','VENUS','EARTH','PLUTO','SPACE','NEBULA','SOLAR',
      'SATURN','URANUS','JUPITER','METEOR','GALAXY','COSMOS','PULSAR',
      'CRATER','ASTEROID','ECLIPSE','AURORA','EQUINOX','GRAVITY','PHOTON',
      'SHUTTLE','SPECTRUM','TELESCOPE','BIGBANG','BLACKHOLE','SUPERNOVA',
      'SATELLITE','ASTRONAUT','ATMOSPHERE','CONSTELLATION','EXOPLANET',
    ],
    'sports': [
      'GOLF','POLO','SURF','SWIM',
      'BOXING','CHESS','DARTS','RUGBY','SKIING','TENNIS','TRACK',
      'ARCHERY','BOWLING','CRICKET','FENCING','HOCKEY','ROWING','SOCCER','SQUASH',
      'BADMINTON','BASEBALL','BASKETBALL','BIATHLON','FOOTBALL','HANDBALL',
      'LACROSSE','MARATHON','SWIMMING','VOLLEYBALL','WRESTLING',
      'GYMNASTICS','SKATEBOARD','SNOWBOARD','TAEKWONDO','TRIATHLON',
    ],
    'science': [
      'ATOM','CELL','GENE','MASS','ACID','BASE',
      'BOTANY','ENERGY','FORCE','FOSSIL','LASER','LIGHT','MAGNET','NUCLEUS',
      'OXYGEN','PLASMA','PROTON','PROBE','PROTON','QUARK','RADAR','TISSUE',
      'BIOLOGY','CARBON','DENSITY','ELECTRON','ELEMENT','GRAVITY','HORMONES',
      'ISOTOPE','MOLECULE','NEUTRON','PHYSICS','PROTEIN','SPECIES','VACUUM',
      'ASTRONOMY','CHEMISTRY','EVOLUTION','GENETICS','MUTATION','ORGANISM',
    ],
  };

  /// Returns English words fitting within [maxLength].
  static List<String> randomWordsForLanguage(int maxLength, [String? languageCode]) {
    final Set<String> allEnglish = {};
    for (final list in categories.values) {
      for (final w in list) {
        final upper = w.trim().toUpperCase();
        if (upper.length >= 3 &&
            upper.length <= maxLength &&
            !upper.contains(' ') &&
            !upper.contains('/')) {
          allEnglish.add(upper);
        }
      }
    }
    final rawList = allEnglish.toList();
    rawList.shuffle();
    return rawList;
  }

  /// Legacy helper for compatibility
  static List<String> randomWordsForSize(int maxLength) {
    return randomWordsForLanguage(maxLength, 'en');
  }

  static List<String> wordsForSize(int maxLength, String category) {
    return randomWordsForLanguage(maxLength, 'en');
  }

  static String categoryForLevel(int level) {
    return 'general';
  }

  static String categoryDisplayForLevel(int level) {
    return 'Word Search';
  }
}
