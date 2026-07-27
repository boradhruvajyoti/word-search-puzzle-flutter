// Word Bank: German (Deutsch) — 1,000+ words
class GermanWords {
  static final List<String> list = _generateWords();

  static List<String> _generateWords() {
    final Set<String> words = {};

    final List<String> baseNouns = [
      'LOEWE','TIGER','ELEFANT','PFERD','HUND','KATZE','BAER','WOLF','FUCHS','AFFEN','HASE','HIRSCH','GIRAFFE','FLUSSPFERD','NASHORN','ESEL','KUH','STIER','SCHAF','ZIEGE','SCHWEIN','EICHHOERNCHEN','MAUS','SCHILDKROETE','KROKODIL','SCHLANGE','FROSCH','FISCH','ADLER','KRAEHE','PAPAGEI','HAHN','ENTE','EULE','PFAU','TAUBE','SPATZ',
      'APFEL','BANANE','ORANGE','TRAUBE','GRANATAPFEL','WASSERMELONE','MELONE','PFIRSICH','APRIKOSE','KIRSCHE','ZITRONE','BIRNE','PFLAUME','ERDBEERE','HIMBEERE','ANANAS','KARTOFFEL','ZWIEBEL','TOMATE','ERBSE','KAROTTE','RETTICH','SPINAT','KOHL','AUBERGINE','GURKE','KNOBLAUCH','PFEFFER','KORIANDER','SALAT',
      'SONNE','MOND','STERN','HIMMEL','ERDE','FLUSS','MEER','OZEAN','BERG','WASSERFALL','SEE','WOLKE','REGEN','WIND','FEUER','WASSER','BODEN','WALD','BLUME','BAUM','PFLANZE','BLATT','AST','WURZEL','SAMEN','SAND','STEIN','HOEHLE','WUESTE','INSEL','TAL','STURM','SCHNEE','NEBEL','LICHT','SCHATTEN',
      'HAUS','ZIMMER','TUER','FENSTER','WAND','DACH','BODEN','STUHL','TISCH','BETT','KISSEN','DECKE','VORHANG','SCHRANK','SPIEGEL','LAMPE','VENTILATOR','UHR','SCHLOSS','SCHLUESSEL','TELLER','GLAS','LOEFFEL','MESSER','SCHERE','NADEL','FADEN','KLEIDUNG','SCHUH','TASCHE','FLASCHE','STIFT','BUCH','PAPIER','BLEISTIFT',
      'MUTTER','VATER','BRUDER','SCHWESTER','SOHN','TOCHTER','GROSSVATER','GROSSMUTTER','ONKEL','TANTE','FREUND','FREUNDIN','KIND','MANN','FRAU','MENSCH','KOENIG','KOENIGIN','LEHRER','ARZT','BAUER','DICHTER','SCHRIFTSTELLER','SAENGER','SCHAUSPIELER','LAND','STADT','DORF',
      'LIEBE','WAHRHEIT','FRIEDEN','FREUDE','GLUECK','HOFFNUNG','TRAUM','MUT','GEDULD','GUETE','WEISHEIT','BILDUNG','ERFOLG','SIEG','GLAUBE','DIENST','EINHEIT','FREIHEIT','BEGEISTERUNG',
      'ROT','GRUEN','BLAU','GELB','WEISS','SCHWARZ','ROSA','VIOLETT','ORANGE','BRAUN','GOLD','SILBER','RUND','LANG','BREIT','GROSS','KLEIN','SUESS','SAUER','SCHARF','HEISS','KALT','ZEIT','HEUTE','MORGEN','MORGENS','MITTAGS','ABENDS','NACHT','TAG','JAHR'
    ];

    final List<String> prefixes = [
      'SONNEN','MOND','STERN','WALD','BERG','FLUSS','SEE','MEER','WIND','REGEN','SCHNEE','LICHT','GOLD','SILBER','STEIN','HAUS','STADT','DORF','BAUM','BLUMEN'
    ];

    final List<String> suffixes = [
      'BERG','BURG','DORF','STADT','WALD','TAL','SEE','FLUSS','BACH','STEIN','HAUS','FELD','LAND','PARK','HOF','WEG','RING','ECK','GAU','TOR'
    ];

    words.addAll(baseNouns);

    for (final p in prefixes) {
      for (final s in suffixes) {
        final w = p + s;
        if (w.runes.length >= 2 && w.runes.length <= 10) words.add(w);
      }
    }

    for (final p in prefixes) {
      for (final n in baseNouns) {
        final w = p + n;
        if (w.runes.length >= 2 && w.runes.length <= 10) words.add(w);
      }
    }

    return words.toList();
  }
}
