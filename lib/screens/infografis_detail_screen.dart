import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/infografis_model.dart';
import '../services/image_cache_manager.dart';

class InfografisDetailScreen extends StatefulWidget {
  final InfografisModel item;

  const InfografisDetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<InfografisDetailScreen> createState() => _InfografisDetailScreenState();
}

class _InfografisDetailScreenState extends State<InfografisDetailScreen> {
  File? localImage;
  bool loading = true;
  bool downloading = false;
  String errorMsg = "";
  int _retry = 0;
  final int _maxRetry = 2;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // ================= LOAD IMAGE =================
  Future<void> _loadImage() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          loading = true;
          errorMsg = "";
        });
      }
    });

    try {
      final cached = await ImageCacheManager.getCachedFile(widget.item.image);
      if (!mounted) return;

      if (cached != null &&
          await cached.exists() &&
          await cached.length() > 0) {
        setState(() {
          localImage = cached;
          loading = false;
        });
        return;
      }

      final file = await ImageCacheManager.getSingleFile(widget.item.image);
      if (!mounted) return;

      setState(() {
        localImage = file;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      _handleError("Terjadi kesalahan saat memuat gambar");
    }
  }

  void _handleError(String msg) {
    if (_retry < _maxRetry) {
      _retry++;
      Future.delayed(const Duration(milliseconds: 600), _loadImage);
    } else {
      setState(() {
        errorMsg = msg;
        loading = false;
      });
    }
  }

  // ================= SAVE TO DOWNLOAD =================
  Future<File?> _saveToDownload(File sourceFile, String fileName) async {
    try {
      Directory dir;

      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
      } else {
        final d = await getDownloadsDirectory();
        if (d == null) return null;
        dir = d;
      }

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final target = File('${dir.path}/$fileName.jpg');

      if (await target.exists()) {
        await target.delete();
      }

      return await sourceFile.copy(target.path);
    } catch (e) {
      debugPrint("SAVE ERROR: $e");
      return null;
    }
  }

  // ================= DOWNLOAD =================
  Future<void> _downloadFile() async {
    if (downloading) return;

    setState(() => downloading = true);

    try {
      File? file = localImage;
      if (file == null || !await file.exists()) {
        file =
            await ImageCacheManager.instance.getSingleFile(widget.item.image);
      }

      if (!mounted) return;

      if (file == null || !await file.exists() || await file.length() == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengunduh gambar")),
        );
        return;
      }

      final saved = await _saveToDownload(
        file,
        "infografis_${widget.item.id}",
      );

      if (!mounted) return;

      if (saved != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil disimpan ke folder Download")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan ke storage")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => downloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(child: _buildImage()),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: downloading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.download),
                  label:
                      Text(downloading ? "Mengunduh..." : "Unduh Infografis"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: downloading ? null : _downloadFile,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= IMAGE VIEW =================
  Widget _buildImage() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (localImage == null ||
        !localImage!.existsSync() ||
        localImage!.lengthSync() == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              errorMsg.isEmpty ? "Gambar gagal dimuat" : errorMsg,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                _retry = 0;
                _loadImage();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Center(
          child: Image.file(
        localImage!,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.low,
      )),
    );
  }
}
