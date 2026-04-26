import 'package:flutter/material.dart';

class AlamatdanKontakPage extends StatelessWidget {
  final String title;
  const AlamatdanKontakPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const Color themeOrange = Color(0xFFFF9800);
    const Color titleBlue = Color(0xFFFF9800);
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

            // Judul Halaman
            const Text(
              "Alamat dan Kontak BPS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleBlue,
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Badan Pusat Statistik Kabupaten Kudus",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            const Text(
              "Hubungi Kami untuk Info Lebih Lanjut",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            _buildContactRow(
              "Kantor",
              "Jl. Mejobo Komplek Perkantoran Kudus No.100 Kabupaten Kudus Provinsi Jawa Tengah 59319",
            ),
            _buildContactRow("Telepon", "(0291) 433382"),
            _buildContactRow("Email", "bps3319@bps.go.id"),
            _buildContactRow("Website", "kuduskab.bps.go.id"),

            const SizedBox(height: 40),

            const Text(
              "Via Media Sosial Kami :",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            // Bagian Media Sosial
            _buildContactRow("Instagram", "@bps_kuduskab"),
            _buildContactRow("Facebook", "BPS Kabupaten Kudus"),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildContactRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          const Text(": ", style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
