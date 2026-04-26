class StatConfig {
  final String varId;
  final String title;
  final String category;

  const StatConfig({
    required this.varId,
    required this.title,
    required this.category,
  });
}

const List<StatConfig> statConfigs = [
  StatConfig(
    varId: '43',
    title: 'Jumlah Penduduk',
    category: 'Sosial dan Kependudukan',
  ),
  StatConfig(
    varId: '44',
    title: 'Rasio Jenis Kelamin',
    category: 'Sosial dan Kependudukan',
  ),
  StatConfig(
    varId: '1025',
    title: 'Tingkat Partisipasi Angkatan Kerja (TPAK)',
    category: 'Sosial dan Kependudukan',
  ),
  StatConfig(
    varId: '1027',
    title: 'Tingkat Pengangguran Terbuka (TPT)',
    category: 'Sosial dan Kependudukan',
  ),
  StatConfig(
    varId: '1032',
    title: 'Garis Kemiskinan',
    category: 'Sosial dan Kependudukan',
  ),
  StatConfig(
    varId: '1035',
    title: 'Persentase Penduduk Miskin (P0)',
    category: 'Sosial dan Kependudukan',
  ),

  // ===== EKONOMI =====
  StatConfig(
    varId: '500',
    title: 'PDRB atas Dasar Harga Berlaku (ADHB)',
    category: 'Ekonomi dan Pariwisata',
  ),
  StatConfig(
    varId: '502',
    title: 'Laju Pertumbuhan Ekonomi (y-on-y)',
    category: 'Ekonomi dan Pariwisata',
  ),
  StatConfig(
    varId: '503',
    title: 'Tingkat Inflasi (y-on-y)',
    category: 'Ekonomi dan Pariwisata',
  ),

  // ===== PERTANIAN =====
  StatConfig(
    varId: '900',
    title: 'Produksi Padi',
    category: 'Pertanian',
  ),
];
