// Word Bank: Turkish (Türkçe) — 1,000+ words
class TurkishWords {
  static final List<String> list = _generateWords();

  static List<String> _generateWords() {
    final Set<String> words = {};

    final List<String> baseNouns = [
      'ASLAN','KAPLAN','FIL','AT','KOPEK','KEDI','AYI','KURT','TILKI','MAYMUN','TAVSAN','GEYIK','ZURAFA','HIPOPOTAM','GERGEDAN','ESEK','INEK','BOGA','KOYUN','KECI','DOMUZ','SINCAP','FARE','KAPLUMBAĞA','TIMSAH','YILAN','KURBAGA','BALIK','KARTAL','KARGA','PAPAĞAN','HOROZ','ORDEK','BAYKUS','TAVUSKUSU','GUVERCIN','SERCE',
      'ELMA','MUZ','PORTAKAL','UZUM','NAR','KARPUZ','KAVUN','SEFTALI','KAYISI','KIRAZ','LIMON','ARMUT','ERIK','CILEK','AHUDUDU','ANANAS','PATATES','SOGAN','DOMATES','BEZELYE','HAVUC','TURP','ISPANAK','LAHANA','PATLICAN','SALATALIK','SARIMSAK','BIBER','MAYDANOZ','MARUL',
      'GUNES','AY','YILDIZ','GOKYUZU','DUNYA','NEHIR','DENIZ','OKYANUS','DAG','SELALE','GOL','BULUT','YAGMUR','RUZGAR','ATES','SU','TOPRAK','ORMAN','CICEK','AGAC','BITKI','YAPRAK','DAL','KOK','TOHUM','KUM','TAS','MAGARA','COL','ADA','VADI','FIRTINA','KAR','SIS','ISIK','GOLGE',
      'EV','ODA','KAPI','PENCERE','DUVAR','CATI','ZEMIN','SANDALYE','MASA','YATAK','YASTIK','YORGAN','PERDE','DOLAP','AYNA','LAMBA','FAN','SAAT','KILIT','ANAHTAR','TABAK','BARDAK','KASIK','BICAK','MAKAS','IGNE','IPLIK','ELBISE','AYAKKABI','CANTA','SISE','KALEM','KITAP','KAGIT','KURSNKALEM',
      'ANNE','BABA','ERKEKKARDES','KIZKARDES','OGUL','KIZ','DEDE','NENE','AMCA','HALA','ARKADAS','DOST','COCUK','ADAM','KADIN','INSAN','KRAL','KRALICE','OGRETMEN','DOKTOR','CIFTCI','SAIR','YAZAR','SHARKISEVER','OYUNCU','ULKE','SEHIR','KOY',
      'SEVGI','GERCEK','BARIS','NESE','MUTLULUK','UMUT','HAYAL','CESARET','SABIR','IYILIK','BILGELIK','EGITIM','BASARI','ZAFER','INANC','HIZMET','BIRLIK','OZGURLUK','HEVES',
      'KIRMIZI','YESIL','MAVI','SARI','BEYAZ','SIYAH','PEMBE','MOR','TURUNCU','KAHVERENGI','ALTIN','GUMUS','YUVARLAK','UZUN','GENIS','BUYUK','KUCUK','TATLI','EKSI','ACI','SICAK','SOGUK','ZAMAN','BUGUN','YARIN','SABAH','OGLEN','AKSAM','GECE','GUN','YIL'
    ];

    final List<String> prefixes = [
      'AK','KARA','GOK','DENIZ','DAG','ORMAN','GOL','NEHIR','AKAR','SU','ATES','ISIK','SES','YOL','EV','KENT','KOY','YILDIZ','GUNES','AY'
    ];

    final List<String> suffixes = [
      'KENT','KOY','DAG','DENIZ','GOL','TEPE','VADI','YOL','BAHCE','ORMAN','KALE','KULE','PINAR','TAS','KAYA','ISIK','GOLGE','YILDIZ','BULUT','RUZGAR'
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
