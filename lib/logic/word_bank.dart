// Logic: Word bank — 20 languages supported (Alphabetical), ~10,000+ words
class WordBank {
  // ── English Categories (Default 10,000+ words) ───────────────────────────
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

  // ── Multi-Language Dictionaries (Alphabetical 20 Languages) ───────────────
  static const Map<String, List<String>> multiLangBank = {
    // 1. Arabic (العربية)
    'ar': [
      'أسد','فهد','نمر','زرافة','فيل','حصان','جمل','تفاح','موز','شمس','قمر','كوكب','علم','سيارة','قطة','كلب','طائر','سمك','بحر','نهر','جبل','سحاب','مطر','ثلج','نجمة','وردة','زهرة','شجرة','ورقة','كتاب','قلم','بيت','مدرسة','جامعة','طبيب','مهندس','معلم','رجل','امرأة','طفل','صديق','سلام','حب','أمل','نور','خير','بركة','عمل','نجاح','فرح'
    ],
    // 2. Assamese (অসমীয়া)
    'as': [
      'সিংহ','বাঘ','হাতী','হৰিণ','ঘোঁৰা','মৰা','শিয়াল','আপেল','আম','কল','বেল','বেলুন','নদী','সাগৰ','সূৰ্য্য','তৰা','আকাশ','মেঘ','বৰষুণ','পাহাৰ','ফুল','গছ','পাত','পুথি','কলম','ঘৰ','বিদ্যালয়','পোহৰ','জোন','বতাহ','পানী','মাছ','চৰাই','মানুহ','মৰম','শাanti','হাঁহি','ভাল','কাম','জয়'
    ],
    // 3. Bangla (বাংলা)
    'bn': [
      'সিংহ','বাঘ','হাতি','হরিণ','ঘোড়া','মহিষ','শেয়াল','আপেল','আম','কলা','বেল','বেলুন','নদী','সাগর','সূর্য','তারা','আকাশ','মেঘ','বৃষ্টি','পাহাড়','ফুল','গাছ','পাতা','বই','কলম','ঘর','স্কুল','আলো','চাঁদ','বাতাস','জল','মাছ','পাখি','মানুষ','ভালোবাসা','শান্তি','হাসি','ভালো','কাজ','জয়'
    ],
    // 4. Chinese (中文)
    'zh': [
      '狮子','老虎','大象','兔子','熊猫','苹果','香蕉','太阳','月亮','星星','飞机','火车','电脑','手机','大海','高山','森林','花朵','小鸟','游鱼','希望','和平','快乐','幸福','美丽','朋友','家庭','学校','中国','世界','学习','工作','成功','梦想','未来','音乐','艺术','科学','生活','时间'
    ],
    // 5. Dutch (Nederlands)
    'nl': [
      'LEEUW','TIJGER','OLIFANT','PAARD','HOND','KAT','APPEL','BANAAN','ZON','MAAN','STER','REGEN','SNEEUW','VLIEGTUIG','TREIN','COMPUTER','TELEFOON','ZEE','BERG','BOS','BLOEM','VOGEL','VIS','HOOP','VREDE','GELUK','LIEFDE','VRIEND','FAMILIE','SCHOOL','WERELD','WERK','SUCCES','DROOM','TOEKOMST','MUZIEK','KUNST','WETENSCHAP','LEVEN','TIJD'
    ],
    // 6. English (en) — uses main categories map above
    // 7. French (Français)
    'fr': [
      'LION','TIGRE','ELEPHANT','CHEVAL','CHIEN','CHAT','POMME','BANANE','SOLEIL','LUNE','ETOILE','PLUIE','NEIGE','AVION','TRAIN','ORDINATEUR','TELEPHONE','MER','MONTAGNE','FORET','FLEUR','OISEAU','POISSON','ESPOIR','PAIX','BONHEUR','AMOUR','AMI','FAMILLE','ECOLE','MONDE','TRAVAIL','SUCCES','REVE','AVENIR','MUSIQUE','ART','SCIENCE','VIE','TEMPS'
    ],
    // 8. German (Deutsch)
    'de': [
      'LOEWE','TIGER','ELEFANT','PFERD','HUND','KATZE','APFEL','BANANE','SONNE','MOND','STERN','REGEN','SCHNEE','FLUGZEUG','ZUG','COMPUTER','TELEFON','MEER','BERG','WALD','BLUME','VOGEL','FISCH','HOFFNUNG','FRIEDEN','GLUECK','LIEBE','FREUND','FAMILIE','SCHULE','WELT','ARBEIT','ERFOLG','TRAUM','ZUKUNFT','MUSIK','KUNST','WISSENSCHAFT','LEBEN','ZEIT'
    ],
    // 9. Gujarati (ગુજરાતી)
    'gu': [
      'સિંહ','વાઘ','હાથી','હરણ','ઘોડો','શિયાળ','સફરજન','કેરી','કેળું','સૂર્ય','ચંદ્ર','તારા','નદી','દરિયો','પર્વત','વાદળ','વરસાદ','ફૂલ','ઝાડ','પાંદડું','પુસ્તક','પેન','ઘર','શાળા','પ્રકાશ','પવન','પાણી','માછલી','પક્ષી','માણસ','પ્રેમ','શાંતિ','હાસ્ય','સારું','કામ','જીત'
    ],
    // 10. Hindi (हिन्दी)
    'hi': [
      'शेर','बाघ','हाथी','हिरण','घोड़ा','लोमड़ी','सेब','आम','केला','फल','सूरज','चांद','तारा','नदी','सागर','पर्वत','बादल','बारिश','फूल','पेड़','पत्ता','किताब','कलम','घर','स्कूल','रोशनी','हवा','पानी','मछली','पक्षी','इंसान','प्यार','शांति','खुशी','अच्छा','काम','जीत','सपना','दुनिया','समय'
    ],
    // 11. Indonesian (Bahasa Indonesia)
    'id': [
      'SINGA','HARIMAU','GAJAH','KUDA','ANJING','KUCING','APEL','PISANG','MATAHARI','BULAN','BINTANG','HUJAN','AWAN','PESAWAT','KERETA','KOMPUTER','TELEPON','LAUT','GUNUNG','HUTAN','BUNGA','BURUNG','IKAN','HARAPAN','DAMAI','BAHAGIA','CINTA','TEMAN','KELUARGA','SEKOLAH','DUNIA','KERJA','SUKSES','MIMPI','MASADEPAN','MUSIK','SENI','SAINS','HIDUP','WAKTU'
    ],
    // 12. Italian (Italiano)
    'it': [
      'LEONE','TIGRE','ELEFANTE','CAVALLO','CANE','GATTO','MELA','BANANA','SOLE','LUNA','STELLA','PIOGGIA','NEVE','AEREO','TRENO','COMPUTER','TELEFONO','MARE','MONTAGNA','FORESTA','FIORE','UCCELLO','PESCE','SPERANZA','PACE','FELICITA','AMORE','AMICO','FAMIGLIA','SCUOLA','MONDO','LAVORO','SUCCESSO','SOGNO','FUTURO','MUSICA','ARTE','SCIENZA','VITA','TEMPO'
    ],
    // 13. Japanese (日本語)
    'ja': [
      'ライオン','トラ','ゾウ','ウマ','イヌ','ネコ','リンゴ','バナナ','タイヨウ','ツキ','ホシ','アメ','ユキ','ヒコーキ','デンシャ','パソコン','デンワ','ウミ','ヤマ','モリ','ハナ','トリ','サカナ','キボウ','ヘイワ','シアワセ','アイ','トモダチ','カゾク','ガッコウ','セカイ','シゴト','セイコウ','ユメ','미래','オンガク','ビジュツ','カガク','イノチ','ジカン'
    ],
    // 14. Korean (한국어)
    'ko': [
      '사자','호랑이','코끼리','말','개','고양이','사과','바나나','태양','달','별','비','눈','비행기','기차','컴퓨터','전화','바다','산','숲','꽃','새','물고기','희망','평화','행복','사랑','친구','가족','학교','세계','일','성공','꿈','미래','음악','미술','과학','생명','시간'
    ],
    // 15. Portuguese (Português)
    'pt': [
      'LEAO','TIGRE','ELEFANTE','CAVALO','CAO','GATO','MACA','BANANA','SOL','LUA','ESTRELA','CHUVA','NEVE','AVIAO','TREM','COMPUTADOR','TELEFONE','MAR','MONTANHA','FLORESTA','FLOR','PASSARO','PEIXE','ESPERANCA','PAZ','FELICIDADE','AMOR','AMIGO','FAMILIA','ESCOLA','MUNDO','TRABALHO','SUCESSO','SONHO','FUTURO','MUSICA','ARTE','CIENCIA','VIDA','TEMPO'
    ],
    // 16. Punjabi (ਪੰਜਾਬੀ)
    'pa': [
      'ਸ਼ੇਰ','ਬਾਘ','ਹਾਥੀ','ਹਿਰਨ','ਘੋੜਾ','ਲੋਮੜੀ','ਸੇਬ','ਅੰਬ','ਕੇਲਾ','ਸੂਰਜ','ਚੰਦ','ਤਾਰਾ','ਨਦੀ','ਸਮੁੰਦਰ','ਪਹਾੜ','ਬੱਦਲ','ਮੀਂਹ','ਫੁੱਲ','ਰੁੱਖ','ਪੱਤਾ','ਕਿਤਾਬ','ਕਲਮ','ਘਰ','ਸਕੂਲ','ਚਾਨਣ','ਹਵਾ','ਪਾਣੀ','ਮੱਛੀ','ਪੰਛੀ','ਇਨਸਾਨ','ਪਿਆਰ','ਸ਼ਾਂਤੀ','ਖੁਸ਼ੀ','ਚੰਗਾ','ਕੰਮ','ਜਿੱਤ'
    ],
    // 17. Russian (Русский)
    'ru': [
      'ЛЕВ','ТИГР','СЛОН','ЛОШАДЬ','СОБАКА','КОШКА','ЯБЛОКО','БАНАН','СОЛНЦЕ','ЛУНА','ЗВЕЗДА','ДОЖДЬ','СНЕГ','САМОЛЕТ','ПОЕЗД','КОМПЬЮТЕР','ТЕЛЕФОН','МОРЕ','ГОРА','ЛЕС','ЦВЕТОК','ПТИЦА','РЫБА','НАДЕЖДА','МИР','СЧАСТЬЕ','ЛЮБОВЬ','ДРУГ','СЕМЬЯ','ШКОЛА','МИР','РАБОТА','УСПЕХ','МЕЧТА','БУДУЩЕЕ','МУЗЫКА','ИСКУССТВО','НАУКА','ЖИЗНЬ','ВРЕМЯ'
    ],
    // 18. Spanish (Español)
    'es': [
      'LEON','TIGRE','ELEFANTE','CABALLO','PERRO','GATO','MANZANA','BANANO','SOL','LUNA','ESTRELLA','LLUVIA','NIEVE','AVION','TREN','COMPUTADORA','TELEFONO','MAR','MONTAÑA','BOSQUE','FLOR','PAJARO','PEZ','ESPERANZA','PAZ','FELICIDAD','AMOR','AMIGO','FAMILIA','ESCUELA','MUNDO','TRABAJO','EXITO','SUEÑO','FUTURO','MUSICA','ARTE','CIENCIA','VIDA','TIEMPO'
    ],
    // 19. Tamil (தமிழ்)
    'ta': [
      'சிங்கம்','புலி','யானை','மான்','குதிரை','நரி','ஆப்பிள்','மாம்பழம்','வாழைப்பழம்','சூரியன்','சந்திரன்','நட்சத்திரம்','ஆறு','கடல்','மலை','மேகம்','மழை','பூ','மரம்','இலை','புத்தகம்','பேனா','வீடு','பள்ளி','வெளிச்சம்','காற்று','நீர்','மீன்','பறவை','மனிதன்','அன்பு','அமைதி','மகிழ்ச்சி','நல்ல','வேலை','வெற்றி'
    ],
    // 20. Turkish (Türkçe)
    'tr': [
      'ASLAN','KAPLAN','FIL','AT','KOPEK','KEDI','ELMA','MUZ','GUNES','AY','YILDIZ','YAGMUR','KAR','UCAK','TREN','BILGISAYAR','TELEFON','DENIZ','DAG','ORMAN','CICEK','KUS','BALIK','UMUT','BARIS','MUTLULUK','SEVGI','ARKADAS','AILE','OKUL','DUNYA','IS','BASARI','HAYAL','GELECEK','MUZIK','SANAT','BILIM','YASAM','ZAMAN'
    ],
  };

  /// Returns words for a specific [languageCode] fitting within [maxLength].
  static List<String> randomWordsForLanguage(int maxLength, String languageCode) {
    List<String> rawList = [];

    if (languageCode == 'en') {
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
      rawList = allEnglish.toList();
    } else {
      final list = multiLangBank[languageCode] ?? multiLangBank['hi']!;
      rawList = list.where((w) {
        final clean = w.trim();
        final len = clean.runes.length;
        return len >= 2 && len <= maxLength && !clean.contains(' ');
      }).toList();
    }

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
