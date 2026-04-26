import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheManager {
  static final CacheManager instance = CacheManager(
    Config(
      'infografis_cache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 300, // ± tergantung ukuran file
      repo: JsonCacheInfoRepository(databaseName: 'infografis_cache_db'),
      fileService: HttpFileService(),
    ),
  );

  static Future<File?> getCachedFile(String url) async {
    final fileInfo = await instance.getFileFromCache(url);
    return fileInfo?.file;
  }

  static Future<File> getSingleFile(String url) async {
    return await instance.getSingleFile(url);
  }

  static Future<void> preloadBatch({
    required List<String> urls,
    required Function(double progress) onProgress,
  }) async {
    int done = 0;

    for (final url in urls) {
      try {
        await instance.downloadFile(url);
      } catch (_) {}

      done++;
      onProgress(done / urls.length);
    }
  }

  static Future<void> clearOldCache() async {
    await instance.emptyCache();
  }
}
