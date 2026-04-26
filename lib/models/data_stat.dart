class DataStat {
  final String kecamatan;
  final String jenis;
  final int value;

  DataStat({
    required this.kecamatan,
    required this.jenis,
    required this.value,
  });

  factory DataStat.fromJson(Map<String, dynamic> json) {
    return DataStat(
      kecamatan: json['vervar']?.toString() ?? 'Tidak diketahui',
      jenis: json['turvar']?.toString() ?? '-',
      value: int.tryParse(json['value']?.toString() ?? '0') ?? 0,
    );
  }
}
