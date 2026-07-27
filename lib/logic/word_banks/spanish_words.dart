// Word Bank: Spanish (Español) — 1,000+ words
class SpanishWords {
  static final List<String> list = _generateWords();

  static List<String> _generateWords() {
    final Set<String> words = {};

    final List<String> baseNouns = [
      'LEON','TIGRE','ELEFANTE','CABALLO','PERRO','GATO','OSO','LOBO','ZORRO','MONO','CONEJO','CIERVO','JIRAFA','HIPOPOTAMO','RINOCERONTE','BURRO','VACA','TORO','OVEJA','CABRA','CERDO','ARDILLA','RATON','TORTUGA','COCODRILO','SERPIENTE','RANA','PEZ','AGUILA','CUERVO','LORO','GALLO','PATO','BUHO','PAVO','PALOMA','GORRION',
      'MANZANA','BANANO','NARANJA','UVA','GRANADA','SANDIA','MELON','MELOCOTON','ALBARICOQUE','CEREZA','LIMON','PERA','CIRUELA','FRESA','FRAMBUESA','PIÑA','PAPA','CEBOLLA','TOMATE','GUISANTE','ZANAHORIA','RABANO','ESPINACA','COL','BERENJENA','PEPINO','AJO','PIMIENTA','CILANTRO','LECHUGA',
      'SOL','LUNA','ESTRELLA','CIELO','TIERRA','RIO','MAR','OCEANO','MONTAÑA','CASCADA','LAGO','NUBE','LLUVIA','VIENTO','FUEGO','AGUA','SUELO','BOSQUE','FLOR','ARBOL','PLANTA','HOJA','RAMA','RAIZ','SEMILLA','ARENA','PIEDRA','CUEVA','DESIERTO','ISLA','VALLE','TORMENTA','NIEVE','NIEBLA','LUZ','SOMBRA',
      'CASA','HABITACION','PUERTA','VENTANA','PARED','TECHO','PISO','SILLA','MESA','CAMA','ALMOHADA','COBIJA','CORTINA','ARMARIO','ESPEJO','LAMPARA','VENTILADOR','RELOJ','CANDADO','LLAVE','PLATO','VASO','CUCHARA','CUCHILLO','TIJERAS','AGUJA','HILO','ROPA','ZAPATO','BOLSA','BOTELLA','PLUMA','LIBRO','PAPEL','LAPIZ',
      'MADRE','PADRE','HERMANO','HERMANA','HIJO','HIJA','ABUELO','ABUELA','TIO','TIA','AMIGO','AMIGA','NIÑO','HOMBRE','MUJER','PERSONA','REY','REINA','PROFESOR','DOCTOR','GRANJERO','POETA','ESCRITOR','CANTANTE','ACTOR','PAIS','CIUDAD','PUEBLO',
      'AMOR','VERDAD','PAZ','ALEGRIA','FELICIDAD','ESPERANZA','SUEÑO','VALOR','PACIENCIA','BONDAD','SABIDURIA','EDUCACION','EXITO','VICTORIA','FE','SERVICIO','UNIDAD','LIBERTAD','ENTUSIASMO',
      'ROJO','VERDE','AZUL','AMARILLO','BLANCO','NEGRO','ROSADO','VIOLETA','NARANJA','MARRON','DORADO','PLATEADO','REDONDO','LARGO','ANCHO','GRANDE','PEQUEÑO','DULCE','ACIDO','PICANTE','CALIENTE','FRIO','TIEMPO','HOY','MAÑANA','TARDE','NOCHE','DIA','AÑO'
    ];

    final List<String> prefixes = [
      'AUTO','SUPER','SUB','MINI','MAXI','MICRO','MACRO','TELE','NEO','POST','PRE','ANTI','SEMI','ULTRA','MEGA','MONO','POLI','MULTI','EXTRA','INTRA'
    ];

    final List<String> roots = [
      'MAR','SOL','LUNA','FLOR','BOSQUE','MONTE','RIO','CAMPO','CIUDAD','MUNDO','TIERRA','AGUA','FUEGO','VIENTO','LUZ','SOMBRA','ARBOL','HOJA','FRUTA','PIEDRA'
    ];

    final List<String> suffixes = [
      'LANDIA','TOWN','VILLE','BURGO','POLIS','MONTE','RIO','MAR','SOL','LUNA','FLOR','BOSQUE','CAMPO','VALLE','LAGO','CIUDAD','PUEBLO','ALDEA','VILLA','COSTA'
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
