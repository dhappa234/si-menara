import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_cache_manager.dart';

class LocalCacheImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;

  const LocalCacheImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  State<LocalCacheImage> createState() => _LocalCacheImageState();
}

class _LocalCacheImageState extends State<LocalCacheImage> {
  File? _localFile;
  bool _error = false;

  int _retry = 0;
  final int _maxRetry = 3;

  @override
  void initState() {
    super.initState();
    _loadCache();
  }

  Future<void> _loadCache() async {
    while (_retry < _maxRetry) {
      try {
        final fileInfo =
            await ImageCacheManager.instance.getFileFromCache(widget.imageUrl);

        if (fileInfo != null && await fileInfo.file.exists()) {
          if (mounted) {
            setState(() {
              _localFile = fileInfo.file;
            });
          }
          return;
        }

        final downloaded =
            await ImageCacheManager.instance.downloadFile(widget.imageUrl);

        if (mounted) {
          setState(() {
            _localFile = downloaded.file;
          });
        }
        return;
      } catch (_) {
        _retry++;
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }

    if (mounted) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_localFile != null) {
      return Image.file(
        _localFile!,
        fit: widget.fit,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_error) {
      return const Center(child: Icon(Icons.broken_image, size: 32));
    }

    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }
}
