import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StrukturOrganisasiPage extends StatelessWidget {
  final String title;
  const StrukturOrganisasiPage({super.key, required this.title});

  // --- LOGIKA DOWNLOAD DARI SUPABASE (SESUAI REQUEST ANDA) ---
  Future<void> _downloadFile(String title) async {
    final supabase = Supabase.instance.client;

    // Mapping Judul di UI dengan Nama File di Bucket Supabase
    Map<String, String> fileMapping = {
      "Peraturan Badan Pusat Statistik Nomor 5 Tahun 2023":
      "Peraturan_Badan_Pusat_Statistik_Nomor_7_Tahun_2023_Tentang_Organisasi_dan_Tata_Kerja_BPS_Provinsi_dan_BPS_Kabupaten_Kota.pdf",
      "Peraturan Badan Pusat Statistik Nomor 7 Tahun 2020":
      "Peraturan_Badan_Pusat_Statistik_Nomor_7_Tahun_2020_Organisasi_dan_Tata_Kerja_BPS.pdf",
    };

    String? fileName = fileMapping[title];

    if (fileName != null) {
      try {
        // Ambil URL Publik
        final String publicUrl = supabase.storage
            .from('profil_bps')
            .getPublicUrl(fileName);

        final Uri url = Uri.parse(publicUrl);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw 'Tidak dapat membuka browser untuk file ini';
        }
      } catch (e) {
        debugPrint("Error Download: $e");
      }
    } else {
      debugPrint("Nama file tidak terdaftar untuk: $title");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color themeOrange = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: themeOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header BPS
            _buildHeaderDropdown(),
            const SizedBox(height: 30),

            const Text(
              "Struktur Organisasi BPS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeOrange,
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              "Berdasarkan Peraturan Presiden Nomor 86 Tahun 2007 tentang Badan Pusat Statistik dan Peraturan Kepala Badan Pusat Statistik Nomor 116 Tahun 2014 tentang Organisasi dan Tata Kerja Badan Pusat Statistik.",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: 25),

            // --- BAGIAN DOWNLOAD PDF ---
            _buildDownloadCard(
              "Peraturan Badan Pusat Statistik Nomor 5 Tahun 2023",
              "969.13 kb",
            ),
            const SizedBox(height: 12),
            _buildDownloadCard(
              "Peraturan Badan Pusat Statistik Nomor 7 Tahun 2020",
              "400.27 kb",
            ),

            const SizedBox(height: 40),

            // --- DIAGRAM STRUKTUR ---
            Center(
              child: Column(
                children: [
                  const Text(
                    "STRUKTUR ORGANISASI\nBPS KABUPATEN KUDUS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeOrange,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildOrgBox("KEPALA", themeOrange),
                  Container(height: 30, width: 2, color: themeOrange),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 60),
                      Container(height: 2, width: 30, color: themeOrange),
                      _buildOrgBox("Subbagian\nUmum", themeOrange),
                    ],
                  ),
                  Container(height: 30, width: 2, color: themeOrange),
                  _buildOrgBox("Kelompok\nJabatan Fungsional", themeOrange),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("BPS Kabupaten Kudus", style: TextStyle(color: Colors.black87)),
          Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(String title, String size) {
    return InkWell(
      // Seluruh area kartu bisa diklik untuk download
      onTap: () => _downloadFile(title),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.description_outlined,
              color: Colors.grey,
              size: 30,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    size,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            // Ikon download menggunakan IconButton agar lebih interaktif
            IconButton(
              onPressed: () => _downloadFile(title),
              icon: const Icon(
                Icons.file_download_outlined,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrgBox(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}