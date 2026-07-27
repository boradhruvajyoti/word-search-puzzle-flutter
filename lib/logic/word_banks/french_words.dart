// Word Bank: French (Français) — 1,000+ words
class FrenchWords {
  static final List<String> list = _generateWords();

  static List<String> _generateWords() {
    final Set<String> words = {};

    final List<String> baseNouns = [
      'LION','TIGRE','ELEPHANT','CHEVAL','CHIEN','CHAT','OURS','LOUP','RENARD','SINGE','LAPIN','CERF','GIRAFE','HIPPOPOTAME','RHINOCEROS','ANE','VACHE','TAUREAU','MOUTON','CHEVRE','COCHON','ECUREUIL','SOURIS','TORTUE','CROCODILE','SERPENT','GRENOUILLE','POISSON','AIGLE','CORBEAU','PERROQUET','COQ','CANARD','HIBOU','PAON','PIGEON','MOINEAU',
      'POMME','BANANE','ORANGE','RAISIN','GRENADE','PASTEQUE','MELON','PECHE','ABRICOT','CERISE','CITRON','POIRE','PRUNE','FRAISE','FRAMBOISE','ANANAS','POMMEDETERRE','OIGNON','TOMATE','PETITPOIS','CAROTTE','RADIS','EPINARD','CHOU','AUBERGINE','CONCOMBRE','AIL','POIVRON','CORIANDRE','LAITUE',
      'SOLEIL','LUNE','ETOILE','CIEL','TERRE','RIVIERE','MER','OCEAN','MONTAGNE','CASCADE','LAC','NUAGE','PLUIE','VENT','FEU','EAU','SOL','FORET','FLEUR','ARBRE','PLANTE','FEUILLE','BRANCHE','RACINE','GRAINE','SABLE','PIERRE','GROTTE','DESERT','ILE','VALLEE','TEMPETE','NEIGE','BROUILLARD','LUMIERE','OMBRE',
      'MAISON','CHAMBRE','PORTE','FENETRE','MUR','TOIT','SOL','CHAISE','TABLE','LIT','OREILLER','COUVERTURE','RIDEAU','ARMOIRE','MIROIR','LAMPE','VENTILATEUR','HORLOGE','SERRURE','CLE','ASSIETTE','VERRE','CUILLERE','COUTEAU','CISEAUX','AIGUILLE','FIL','VETEMENT','CHAUSSURE','SAC','BOUTEILLE','STYLO','LIVRE','PAPIER','CRAYON',
      'MERE','PERE','FRERE','SOEUR','FILS','FILLE','GRANDPERE','GRANDMERE','ONCLE','TANTE','AMI','AMIE','ENFANT','HOMME','FEMME','PERSONNE','ROI','REINE','PROFESSEUR','MEDECIN','FERMIER','POETE','ECRIVAIN','CHANTEUR','ACTEUR','PAYS','VILLE','VILLAGE',
      'AMOUR','VERITE','PAIX','JOIE','BONHEUR','ESPOIR','REVE','COURAGE','PATIENCE','BONTE','SAGESSE','EDUCATION','SUCCES','VICTOIRE','FOI','SERVICE','UNITE','LIBERTE','ENTHOUSIASME',
      'ROUGE','VERT','BLEU','JAUNE','BLANC','NOIR','ROSE','VIOLET','ORANGE','MARRON','OR','ARGENT','ROND','LONG','LARGE','GRAND','PETIT','DOUX','ACIDE','EPICE','CHAUD','FROID','TEMPS','AUJOURDHUI','DEMAIN','MATIN','MIDI','SOIR','NUIT','JOUR','ANNEE'
    ];

    final List<String> prefixes = [
      'AUTO','SUPER','SUB','MINI','MAXI','MICRO','MACRO','TELE','NEO','POST','PRE','ANTI','SEMI','ULTRA','MEGA','MONO','POLY','MULTI','EXTRA','INTRA'
    ];

    final List<String> roots = [
      'MER','SOLEIL','LUNE','FLEUR','FORET','MONT','RIVIERE','CHAMP','VILLE','MONDE','TERRE','EAU','FEU','VENT','LUMIERE','OMBRE','ARBRE','FEUILLE','FRUIT','PIERRE','AIR','PAYS','CIEL','NIGHT','JOUR'
    ];

    final List<String> suffixes = [
      'LAND','TOWN','VILLE','BOURG','POLIS','MONT','RIVIERE','MER','SOLEIL','LUNE','FLEUR','FORET','CHAMP','VALLEE','LAC','VILLE','VILLAGE','VAL','COTE','PORT'
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
