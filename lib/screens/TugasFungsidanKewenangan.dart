import 'package:flutter/material.dart';

class TugasFungsidanKewenanganPage extends StatelessWidget {
  final String title;
  const TugasFungsidanKewenanganPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: themeColor,
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
            // Dropdown Header (BPS Kabupaten Kudus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "BPS Kabupaten Kudus",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                ],
              ),
            ),
            const SizedBox(height: 35),

            const Text(
              "Tugas, Fungsi, dan Kewenangan BPS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 15),

            // Teks Pembuka
            const Text(
              "Tugas, fungsi dan kewenangan BPS telah ditetapkan berdasarkan Peraturan Presiden Nomor 86 Tahun 2007 tentang Badan Pusat Statistik dan Peraturan Kepala Badan Pusat Statistik Nomor 7 Tahun 2008 tentang Organisasi dan Tata Kerja Badan Pusat Statistik.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                height: 1.5,
                fontSize: 14,
                color: Color(0xE6000000),
              ),
            ),
            const SizedBox(height: 15),

            // --- SEKSI 1: TUGAS ---
            const Text(
              "1. Tugas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 8, bottom: 15),
              child: Text(
                "Melaksanakan tugas pemerintahan dibidang statistik sesuai peraturan perundang-undangan.",
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.5),
              ),
            ),

            // --- SEKSI 2: FUNGSI ---
            const Text(
              "2. Fungsi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildAlphaItem(
              "a",
              "Pengkajian, penyusunan dan perumusan kebijakan dibidang statistik;",
            ),
            _buildAlphaItem(
              "b",
              "Pengkoordinasian kegiatan statistik nasional dan regional;",
            ),
            _buildAlphaItem(
              "c",
              "Penetapan dan penyelenggaraan statistik dasar;",
            ),
            _buildAlphaItem("d", "Penetapan sistem statistik nasional;"),
            _buildAlphaItem(
              "e",
              "Pembinaan dan fasilitasi terhadap kegiatan instansi pemerintah dibidang kegiatan statistik; dan",
            ),
            _buildAlphaItem(
              "f",
              "Penyelenggaraan pembinaan dan pelayanan administrasi umum dibidang perencanaan umum, ketatausahaan, organisasi dan tatalaksana, kepegawaian, keuangan, kearsipan, kehumasan, hukum, perlengkapan dan rumah tangga.",
            ),

            const SizedBox(height: 15),

            // --- SEKSI 3: KEWENANGAN ---
            const Text(
              "3. Kewenangan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildAlphaItem(
              "a",
              "Penyusunan rencana nasional secara makro di bidangnya;",
            ),
            _buildAlphaItem(
              "b",
              "Perumusan kebijakan di bidangnya untuk mendukung pembangunan secara makro;",
            ),
            _buildAlphaItem("c", "Penetapan sistem informasi di bidangnya;"),
            _buildAlphaItem(
              "d",
              "Penetapan dan penyelenggaraan statistik nasional;",
            ),
            _buildAlphaItem(
              "e",
              "Kewenangan lain sesuai dengan ketentuan peraturan perundang-undangan yang berlaku, yaitu;",
            ),

            // Sub-poin i dan ii di bawah kewenangan e
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                children: [
                  _buildAlphaItem(
                    "i",
                    "Perumusan dan pelaksanaan kebijakan tertentu di bidang kegiatan statistik;",
                  ),
                  _buildAlphaItem(
                    "ii",
                    "Penyusun pedoman penyelenggaraan survei statistik sektoral.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildAlphaItem(String label, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              "$label. ",
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.5, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
