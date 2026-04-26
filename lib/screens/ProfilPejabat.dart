import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilPejabatPage extends StatelessWidget {
  final String title;
  const ProfilPejabatPage({super.key, required this.title});

  // --- TAMBAHAN LOGIKA DOWNLOAD ---
  Future<void> _downloadFile(String title) async {
    final supabase = Supabase.instance.client;

    Map<String, String> fileMapping = {
      "Bukti Laporan SPT 2024 Eko Suharto":
          "Bukti_Laporan_SPT_2024_Eko_Suharto_1750074274.pdf",
      "LHKPN Eko Suharto 2024": "LHKPN_Eko_Suharto_2024_1742183248.pdf",
      "LHKPN Eko Suharto 2023": "LHKPN_Eko_Suharto_2023_1733191732.pdf",
      "LHKASN (SPT Tahunan Pegawai Tahun 2023)":
          "LHKASN__SPT_Tahunan_Pegawai_Tahun_2023__1731555693.pdf",
      "LHKASN (SPT Tahunan Pegawai BPS Tahun 2023)":
          "LHKASN__SPT_Tahunan_Pegawai_Tahun_2023__1731555693 (1).pdf",
      "Bukti Laporan SPT 2024 Nuschiana":
          "Bukti_Laporan_SPT_2024_Nuschiana_1750074291.pdf",
      "LHKASN (SPT) 2023 Nuschiana":
          "LHKASN__SPT__2023_Nuschiana_1727154621.pdf",
      "LHKPN Oki Danang 2024": "LHKPN_Oki_Danang_2024_1742183314.pdf",
      "LHKPN Oki Danang 2023": "LHKPN_2023_Oki_Danang_1731555627.pdf",
      "LHKPN Dyah Ayu 2024": "LHKPN_Dyah_Ayu_2024_1742183268.pdf",
      "LHKPN Dyah Ayu 2023": "LHKPN_2023_Dyah_Ayu_1731555657.pdf",
      "LHKPN Silfi Fahrida 2024": "LHKPN_Silfi_Fahrida_1742183286.pdf",
      "LHKPN Silfi Fahrida 2023": "LHKPN_2023_Silfi_Fahrida_1731555644.pdf",
      "LHKASN (SPT Tahunan Pegawai Tahun 2024)":
          "LHKASN (SPT Tahunan Pegawai Tahun 2024) (1).pdf",
    };

    String? fileName = fileMapping[title];

    if (fileName != null) {
      try {
        final String publicUrl =
            supabase.storage.from('profil_bps').getPublicUrl(fileName);

        final Uri url = Uri.parse(publicUrl);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw 'Tidak dapat membuka file';
        }
      } catch (e) {
        debugPrint("Error Download: $e");
      }
    } else {
      debugPrint("File name tidak ditemukan untuk judul: $title");
    }
  }

  // --- AKHIR TAMBAHAN LOGIKA ---

  @override
  Widget build(BuildContext context) {
// Diperbaiki sedikit ke biru BPS
    const Color bpsOrange = Color(0xFFF7941D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(color: bpsOrange, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDropdownHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profil Pejabat BPS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D428A),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildDetailPejabat(
                    nama: "Eko Suharto, S.ST., M.Si",
                    jabatan: "Kepala BPS Kabupaten Kudus",
                    imageUrl: "assets/images/eko_suharto.png",
                    deskripsi:
                        "Lulus dari Sekolah Tinggi Ilmu Statistik tahun 2000 kemudian meneruskan pendidikan Strata 2 di Institut Teknologi 10 November Surabaya jurusan Statistika. Mengawali karir di BPS pada tahun 2000 sebagai staf pada BPS Provinsi Jawa Barat. Sebelum menjabat Kepala BPS Kabupaten Kudus bertugas sebagai Statistisi Ahli Madya pada BPS Provinsi Jawa Tengah.",
                    dokumen: [
                      {
                        "title": "Bukti Laporan SPT 2024 Eko Suharto",
                        "size": "70.46 kb",
                      },
                      {"title": "LHKPN Eko Suharto 2024", "size": "139.37 kb"},
                      {"title": "LHKPN Eko Suharto 2023", "size": "139.02 kb"},
                      {
                        "title": "LHKASN (SPT Tahunan Pegawai Tahun 2023)",
                        "size": "512.18 kb",
                      },
                    ],
                  ),
                  const SizedBox(height: 50),
                  _buildDetailPejabat(
                    nama: "Nuschiana, S.ST",
                    jabatan: "Kasubbag Umum BPS Kabupaten Kudus",
                    imageUrl: "assets/images/nuschiana.png",
                    deskripsi:
                        "Lulus dari Sekolah Tinggi Ilmu Statistik tahun 2002. Mengawali karir di BPS pada tahun 1999 sebagai staf di BPS Kabupaten Lahat. Sebelum menjabat Kasubbag Umum BPS Kabupaten Kudus bertugas sebagai Statistisi Ahli Muda pada Statistik Produksi BPS Kabupaten Kudus.",
                    dokumen: [
                      {
                        "title": "Bukti Laporan SPT 2024 Nuschiana",
                        "size": "75.58 kb",
                      },
                      {
                        "title": "LHKASN (SPT) 2023 Nuschiana",
                        "size": "13.56 kb",
                      },
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Ikhtisar LHKPN Pejabat Keuangan BPS Kabupaten Kudus",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildDownloadCard("LHKPN Oki Danang 2024", "144.68 kb"),
                  _buildDownloadCard("LHKPN Oki Danang 2023", "144.16 kb"),
                  _buildDownloadCard("LHKPN Dyah Ayu 2024", "132.66 kb"),
                  _buildDownloadCard("LHKPN Dyah Ayu 2023", "137.68 kb"),
                  _buildDownloadCard("LHKPN Silfi Fahrida 2024", "137.81 kb"),
                  _buildDownloadCard("LHKPN Silfi Fahrida 2023", "132.28 kb"),
                  _buildDownloadCard(
                    "LHKASN (SPT Tahunan Pegawai BPS Tahun 2023)",
                    "512.18 kb",
                  ),
                  _buildDownloadCard(
                    "LHKASN (SPT Tahunan Pegawai Tahun 2024)",
                    "1.91 mb",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

  Widget _buildDetailPejabat({
    required String nama,
    required String jabatan,
    required String imageUrl,
    required String deskripsi,
    required List<Map<String, String>> dokumen,
  }) {
    return Column(
      children: [
        Text(
          "$nama - $jabatan",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Center(
          child: Image.asset(
            imageUrl,
            height: 280,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.person, size: 200, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          deskripsi,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            height: 1.6,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        ...dokumen
            .map((doc) => _buildDownloadCard(doc['title']!, doc['size']!)),
      ],
    );
  }

  Widget _buildDownloadCard(String title, String size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.insert_drive_file_outlined,
          color: Colors.grey,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          size,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.download_rounded,
          color: Color(0xFF4CAF50),
          size: 24,
        ),
        onTap: () => _downloadFile(title), // HUBUNGAN KE LOGIKA DOWNLOAD
      ),
    );
  }
}
