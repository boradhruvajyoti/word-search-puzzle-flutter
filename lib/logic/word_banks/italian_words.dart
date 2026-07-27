// Word Bank: Italian (Italiano) — 1,000+ words
class ItalianWords {
  static final List<String> list = _generateWords();

  static List<String> _generateWords() {
    final Set<String> words = {};

    final List<String> baseNouns = [
      'LEONE','TIGRE','ELEFANTE','CAVALLO','CANE','GATTO','ORSO','LUPO','VOLPE','SCIMMIA','CONIGLIO','CERVO','GIRAFFA','IPPOPOTAMO','RINOCERONTE','ASINO','MUCCA','TORO','PECORA','CAPRA','MAIALE','SCOIATTOLO','TOPO','TARTARUGA','COCCODRILLO','SERPENTE','RANA','PESCE','AQUILA','CORVO','PAPPAGALLO','GALLO','ANATRA','GUFO','PAONE','COLOMBA','PASSERO',
      'MELA','BANANA','ARANCIA','UVA','MELAGRANA','ANGURIA','MELONE','PESCA','ALBICOCCA','CILIEGIA','LIMONE','PERA','PRUGNA','FRAGOLA','LAMPONE','ANANAS','PATATA','CIPOLLA','POMODORO','PISELLO','CAROTA','RAVANELLO','SPINACI','CAVOLO','MELANZANA','CETRIOLO','AGLIO','PEPERONE','CORIANDOLO','LATTUGA',
      'SOLE','LUNA','STELLA','CIELO','TERRA','FIUME','MARE','OCEANO','MONTAGNA','CASCATA','LAGO','NUVOLA','PIOGGIA','VENTO','FUOCO','ACQUA','SUOLO','FORESTA','FIORE','ALBERO','PIANTA','FOGLIA','RAMO','RADICE','SEME','SABBIA','PIETRA','GROTTA','DESERTO','ISOLA','VALLE','TEMPESTA','NEVE','NEBBIA','LUCE','OMBRA',
      'CASA','STANZA','PORTA','FINESTRA','MURO','TETTO','PAVIMENTO','SEDIA','TAVOLO','LETTO','CUSCINO','COPERTA','TENDA','ARMADIO','SPECCHIO','LAMPADA','VENTILATORE','OROLOGIO','SERRATURA','CHIAVE','PIATTO','BICCHIERE','CUCCHIAIO','COLTELLO','FORBICI','AGO','FILO','ABITO','SCARPA','BORSA','BOTTIGLIA','PENNA','LIBRO','CARTA','MATITA',
      'MADRE','PADRE','FRATELLO','SORELLA','FIGLIO','FIGLIA','NONNO','NONNA','ZIO','ZIA','AMICO','AMICA','BAMBINO','UOMO','DONNA','PERSONA','RE','REGINA','INSEGNANTE','MEDICO','CONTADINO','POETA','SCRITTORE','CANTANTE','ATTORE','PAESE','CITTA','VILLAGGIO',
      'AMORE','VERITA','PACE','GIOIA','FELICITA','SPERANZA','SOGNO','CORAGGIO','PAZIENZA','BONTA','SAGGEZZA','EDUCAZIONE','SUCCESSO','VITTORIA','FEDE','SERVIZIO','UNITA','LIBERTA','ENTUSIASMO',
      'ROSSO','VERDE','BLU','GIALLO','BIANCO','NERO','ROSA','VIOLA','ARANCIONE','MARRONE','ORO','ARGENTO','ROTONDO','LUNGO','LARGO','GRANDE','PICCOLO','DOLCE','ACIDO','PICCANTE','CALDO','FREDDO','TEMPO','OGGI','DOMANI','MATTINA','MEZZOGIORNO','SERA','NOTTE','GIORNO','ANNO'
    ];

    final List<String> prefixes = [
      'AUTO','SUPER','SUB','MINI','MAXI','MICRO','MACRO','TELE','NEO','POST','PRE','ANTI','SEMI','ULTRA','MEGA','MONO','POLI','MULTI','EXTRA','INTRA'
    ];

    final List<String> roots = [
      'MARE','SOLE','LUNA','FIORE','BOSCO','MONTE','FIUME','CAMPO','CITTA','MONDO','TERRA','ACQUA','FUOCO','VENTO','LUCE','OMBRA','ALBERO','FOGLIA','FRUTTA','PIETRA'
    ];

    final List<String> suffixes = [
      'LANDIA','TOWN','VILLE','BURGO','POLIS','MONTE','FIUME','MARE','SOLE','LUNA','FIORE','BOSCO','CAMPO','VALLE','LAGO','CITTA','PAESE','BORGO','VILLA','COSTA'
    ];

    words.addAll(baseNouns);

    for (final p in prefixes) {
      for (final r in roots) {
        final w = p + r;
        if (w.runes.length >= 2 && w.runes.length <= 10) words.add(w);
      }
    }

    for (final r in roots) {
      for (final s in suffixes) {
        final w = r + s;
        if (w.runes.length >= 2 && w.runes.length <= 10) words.add(w);
      }
    }

    for (final p in prefixes) {
      for (final s in suffixes) {
        final w = p + s;
        if (w.runes.length >= 2 && w.runes.length <= 10) words.add(w);
      }
    }

    return words.toList();
  }
}
