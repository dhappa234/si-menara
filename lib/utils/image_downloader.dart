import 'dart:io';
import '../services/image_cache_manager.dart';

class ImageDownloader {
  /// Ambil dari cache dulu, kalau belum ada → download ke temporary cache
  static Future<File?> downloadImage(String url) async {
    try {
      // 1️⃣ Cek cache
      final cached = await ImageCacheManager.getCachedFile(url);
      if (cached != null &&
          await cached.exists() &&
          await cached.length() > 0) {
        return cached;
      }

      // 2️⃣ Download via CacheManager (masuk temp storage)
      final file = await ImageCacheManager.instance.getSingleFile(url);

      if (await file.exists() && await file.length() > 0) {
        return file;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
