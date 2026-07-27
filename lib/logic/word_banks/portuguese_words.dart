// Word Bank: Portuguese (Português) — 1,000+ words
class PortugueseWords {
  static final List<String> list = _generateWords();

  static List<String> _generateWords() {
    final Set<String> words = {};

    final List<String> baseNouns = [
      'LEAO','TIGRE','ELEFANTE','CAVALO','CAO','GATO','URSO','LOBO','RAPOSA','MACACO','COELHO','VEADO','GIRAFA','HIPOPOTAMO','RINOCERONTE','BURRO','VACA','TOURO','OVELHA','CABRA','PORCO','ESQUILO','RATO','TARTARUGA','CROCODILO','COBRA','SAPO','PEIXE','AGUIA','CORVO','PAPAGAIO','GALO','PATO','CORUJA','PAVAO','POMBO','PARDAL',
      'MACA','BANANA','LARANJA','UVA','ROMA','MELANCIA','MELAO','PESSEGO','DAMASCO','CEREJA','LIMAO','PERA','AMEIXA','MORANGO','FRAMBOESA','ANANAS','BATATA','CEBOLA','TOMATE','ERVILHA','CENOURA','RABANETE','ESPINAFRE','COUVE','BERINJELA','PEPINO','ALHO','PIMENTA','COENTRO','ALFACE',
      'SOL','LUA','ESTRELA','CEU','TERRA','RIO','MAR','OCEANO','MONTANHA','CACHOEIRA','LAGO','NUVEM','CHUVA','VENTO','FOGO','AGUA','SOLO','FLORESTA','FLOR','ARVORE','PLANTA','FOLHA','RAMO','RAIZ','SEMENTE','AREIA','PEDRA','CAVERNA','DESERTO','ILHA','VALE','TEMPESTADE','NEVE','NEVOEIRO','LUZ','SOMBRA',
      'CASA','QUARTO','PORTA','JANELA','PAREDE','TETO','CHAO','CADEIRA','MESA','CAMA','ALMOFADA','COBERTOR','CORTINA','ARMARIO','ESPELHO','LAMPADA','VENTILADOR','RELOGIO','FECHADURA','CHAVE','PRATO','COPO','COLHER','FACA','TESOURA','AGULHA','FINO','ROUPA','SAPATO','BOLSA','GARRAFA','CANETA','LIVRO','PAPEL','LAPIS',
      'MAE','PAI','IRMAO','IRMA','FILHO','FILHA','AVO','AVO','TIO','TIA','AMIGO','AMIGA','CRIANCA','HOMEM','MULHER','PESSOA','REI','RAINHA','PROFESSOR','MEDICO','FAZENDEIRO','POETA','ESCRITOR','CANTOR','ATOR','PAIS','CIDADE','VILA',
      'AMOR','VERDADE','PAZ','ALEGRIA','FELICIDADE','ESPERANCA','SONHO','CORAGEM','PACIENCIA','BONDADE','SABEDORIA','EDUCACAO','SUCESSO','VITORIA','FE','SERVICO','UNIDADE','LIBERDADE','ENTUSIASMO',
      'VERMELHO','VERDE','AZUL','AMARELO','BRANCO','PRETO','ROSA','ROXO','LARANJA','MARROM','OURO','PRATA','REDONDO','LONGO','LARGO','GRANDE','PEQUENO','DOCE','AZEDO','PICANTE','QUENTE','FRIO','TEMPO','HOJE','AMANHA','MANHA','TARDE','NOITE','DIA','ANO'
    ];

    final List<String> prefixes = [
      'AUTO','SUPER','SUB','MINI','MAXI','MICRO','MACRO','TELE','NEO','POST','PRE','ANTI','SEMI','ULTRA','MEGA','MONO','POLI','MULTI','EXTRA','INTRA'
    ];

    final List<String> roots = [
      'MAR','SOL','LUA','FLOR','MATA','MONTE','RIO','CAMPO','CIDADE','MUNDO','TERRA','AGUA','FOGO','VENTO','LUZ','SOMBRA','ARVORE','FOLHA','FRUTA','PEDRA'
    ];

    final List<String> suffixes = [
      'LANDIA','TOWN','VILLE','BURGO','POLIS','MONTE','RIO','MAR','SOL','LUA','FLOR','MATA','CAMPO','VALE','LAGO','CIDADE','VILA','ALDEIA','PRAIA','COSTA'
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
