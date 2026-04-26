class InfografisModel {
  final int id;
  final String title;
  final String image;
  final String desc;
  final int category;
  final String download;

  InfografisModel({
    required this.id,
    required this.title,
    required this.image,
    required this.desc,
    required this.category,
    required this.download,
  });

  factory InfografisModel.fromJson(Map<String, dynamic> json) {
    String proxyImage(String? url) {
      if (url == null || url.isEmpty) return "";
      // Pakai proxy supaya tidak diblok BPS
      return
        "https://api.allorigins.win/raw?url=${Uri.encodeComponent(url)}";
    }

    // ================= FIX DOWNLOAD =================
    String fixUrl(String? path) {
      if (path == null || path.isEmpty) return "";
      if (path.startsWith('http')) return path;

      String cleanPath =
      path.startsWith('/') ? path.substring(1) : path;

      return "https://webapi.bps.go.id/$cleanPath";
    }

    final String imageUrl = json['img'] ?? '';

    return InfografisModel(
      id: json['inf_id'] ?? 0,
      title: json['title'] ?? '',
      image: proxyImage(imageUrl), // ← PENTING
      desc: json['desc'] ?? '',
      category: json['category'] ?? 0,
      download: fixUrl(json['dl']),
    );
  }
}
