import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class KelolaPermintaanPage extends StatefulWidget {
  const KelolaPermintaanPage({super.key});

  @override
  State<KelolaPermintaanPage> createState() => _KelolaPermintaanPageState();
}

class _KelolaPermintaanPageState extends State<KelolaPermintaanPage> {
  final Stream<List<Map<String, dynamic>>> _permintaanStream = Supabase
      .instance.client
      .from('permintaan_data')
      .stream(primaryKey: ['id']).order('created_at', ascending: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Kelola Permintaan Data',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _permintaanStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final dataPermintaan = snapshot.data ?? [];

          if (dataPermintaan.isEmpty) {
            return const Center(
                child: Text('Belum ada permintaan data masuk.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: dataPermintaan.length,
            itemBuilder: (context, index) {
              final item = dataPermintaan[index];
              final String namaPengirim =
                  item['nama'] ?? 'Nama Tidak Terdaftar';
              final String emailPengirim = item['email'] ?? 'Email Kosong';
              final String keperluan =
                  item['keperluan'] ?? 'Tidak ada keterangan keperluan';
              final String status = item['status'] ?? 'Menunggu';
              final String? fileUrl = item['file_url'];

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(Icons.person, color: Colors.orange),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          namaPengirim,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getStatusColor(status)),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Email: $emailPengirim",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.blueGrey)),
                      Text(
                          "Keperluan: $keperluan",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                  trailing: const Icon(Icons.open_in_new, color: Colors.blue),
                  isThreeLine: true,
                  onTap: () {
                    if (fileUrl != null && fileUrl.isNotEmpty) {
                      _launchURL(fileUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Lampiran file tidak ditemukan')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      // Tampilkan loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Text('Membuka file...'),
              ],
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Download file dari URL
      final response = await http.get(Uri.parse(url));

      final directory = await getTemporaryDirectory();

      // Ambil nama file dari URL
      final fileName = url.split('/').last;
      final filePath = '${directory.path}/$fileName';

      // Simpan file ke local storage
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Buka file dengan aplikasi viewer yang sesuai
      final result = await OpenFilex.open(filePath);

      if (result.type == ResultType.done) {
        debugPrint("File berhasil dibuka: ${result.message}");
      } else {
        debugPrint("Gagal membuka file: ${result.message}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membuka file: ${result.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error membuka file: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}