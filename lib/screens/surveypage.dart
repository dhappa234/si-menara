import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class HasilSurveyPage extends StatefulWidget {
  const HasilSurveyPage({super.key});

  @override
  State<HasilSurveyPage> createState() => _HasilSurveyPageState();
}

class _HasilSurveyPageState extends State<HasilSurveyPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<List<Map<String, dynamic>>> fetchSurveys() async {
    try {
      debugPrint("Mengambil data dari tabel 'survey'...");
      final response = await supabase
          .from('survey')
          .select()
          .order('created_at', ascending: false);
      debugPrint("Response dari Supabase: $response");
      debugPrint("Jumlah data: ${response.length}");
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Terjadi kesalahan pengambilan data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color themeOrange = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Kelola Hasil Survey',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSurveys(),
        builder: (context, snapshot) {
          debugPrint("Connection state: ${snapshot.connectionState}");
          debugPrint("Has error: ${snapshot.hasError}");
          debugPrint("Has data: ${snapshot.hasData}");
          if (snapshot.hasData) {
            debugPrint("Data length: ${snapshot.data!.length}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: themeOrange));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Gagal sinkronisasi data: ${snapshot.error}'));
          }

          final surveys = snapshot.data ?? [];
          debugPrint("Final surveys count: ${surveys.length}");

          if (surveys.isEmpty) {
            return const Center(
                child: Text('Tidak ada data survey di database.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              final item = surveys[index];
              final DateTime createdAt = item['created_at'] != null
                  ? DateTime.parse(item['created_at'])
                  : DateTime.now();

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 10),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_turned_in_outlined,
                        color: themeOrange),
                  ),
                  // Menampilkan kolom nama_responden dari Supabase [cite: 42, 477]
                  title: Text(
                    item['nama_responden'] ?? 'Anonim',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Menampilkan kolom hasil_survey dan rating jika ada [cite: 285, 312]
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text("Rating: ${item['rating'] ?? '-'} Bintang"),
                      Text("Komentar: ${item['saran'] ?? 'Tidak ada masukan'}"),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(createdAt),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
