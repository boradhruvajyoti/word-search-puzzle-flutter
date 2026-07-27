// Word Bank: Indonesian (Bahasa Indonesia) — 1,000+ words
class IndonesianWords {
  static final List<String> list = _generateWords();

  static List<String> _generateWords() {
    final Set<String> words = {};

    final List<String> baseNouns = [
      'SINGA','HARIMAU','GAJAH','KUDA','ANJING','KUCING','BERUANG','SERIGALA','RUBAH','MONYET','KELINCI','RUSA','JERAPAH','KUDANIL','BADAK','KELEDAI','SAPI','BANTENG','DOMBA','KAMBING','BABI','TUPAI','TIKUS','KURA-KURA','BUAYA','ULAR','KATAK','IKAN','ELANG','GAGAK','BEO','AYAM','BEBEK','BURUNGHANTU','MERAK','MERPATI','BURUNG',
      'APEL','PISANG','JERUK','ANGGUR','DELIMA','SEMANGKA','MELON','PERSIK','APRIKOT','CERI','MON','PIR','SUBAN','STROBERI','AMER','NANAS','KENTANG','BAWANG','TOMAT','KACANG','WORTEL','LOBAK','BAYAM','KUBIS','TERONG','MENTIMUN','BAWANGPUTIH','CABAI','KETUMBAR','SELADA',
      'MATAHARI','BULAN','BINTANG','LANGIT','BUMI','SUNGAI','LAUT','SAMUDRA','GUNUNG','AIRTERJUN','DANAU','AWAN','HUJAN','ANGIN','API','AIR','TANAH','HUTAN','BUNGA','POHON','TANAMAN','DAUN','DANTING','AKAR','BIJI','PASIR','BATU','GUA','GURUN','PULAU','LEMBAH','BADAI','SALJU','KABUT','CAHAYA','BAYANGAN',
      'RUMAH','KAMAR','PINTU','JENDELA','DINDING','ATAP','LANTAI','KURSI','MEJA','KASUR','BANTAL','SELIMUT','TIRAI','LEMARI','CERMIN','LAMPU','KIPAS','JAM','KUNCI','KUNCI','PIRING','GELAS','SENDOK','PISAU','GUNTING','JARUM','BENANG','PAKAIAN','SEPATU','TAS','BOTOL','PENA','BUKU','KERTAS','PENSIL',
      'IBU','AYAH','SAUDARA','SAUDARI','ANAK','PUTRI','KAKEK','NENEK','PAM AN','BIBI','TEMAN','SAHABAT','ANAK','PRIA','WANITA','MANUSIA','RAJA','RATU','GURU','DOKTER','PETANI','PENYAIR','PENULIS','PENYANYI','AKTOR','NEGARA','KOTA','DESA',
      'CINTA','KEBENARAN','KEDAMAIAN','KEGEMBIRAAN','KEBAHAGIAAN','HARAPAN','MIMPI','KEBERANIAN','KESABARAN','KEBAIKAN','KEBIJAKSANAAN','PENDIDIKAN','SUKSES','KEMENANGAN','IMAN','PELAYANAN','PERSATUAN','KEBEBASAN','SEMANGAT',
      'MERAH','HIJAU','BIRU','KUNING','PUTIH','HITAM','MERAHMUDA','UNGU','ORANYE','COKLAT','EMAS','PERAK','BULAT','PANJANG','LEBAR','BESAR','KECIL','MANIS','ASAM','PEDAS','PANAS','DINGIN','WAKTU','HARIINI','BESOK','PAGI','SIANG','SORE','MALAM','HARI','TAHUN'
    ];

    final List<String> prefixes = [
      'NUSA','KOTA','DESA','GUNUNG','LAUT','SUNGAI','DANAU','PULAU','RIMBA','TAMAN','TIRTA','MAHA','NUSA','SARI','MEGA','EKA','DWI','TRI','PANCA','WIRA'
    ];

    final List<String> suffixes = [
      'JAYA','SARI','PURA','GIRI','TAMA','MUKTI','AGUNG','INDAH','ASRI','TIRTA','KARTA','MULYA','SUCI','RAYA','HARJA','SUBUR','BEKASI','BOGOR','SOLO','MEDAN'
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
