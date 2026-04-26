import 'package:flutter/material.dart';

class ArtiLogoPage extends StatelessWidget {
  final String title;
  const ArtiLogoPage({super.key, required this.title});

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
            // Dropdown Header
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
            const SizedBox(height: 30),
            const Text(
              "Arti Logo BPS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: Image.asset(
                'assets/images/logo_bps.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Logo pada Badan Pusat Statistik memiliki warna biru, hijau dan orange dan disetiap warna memiliki arti khusus, yaitu :",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Bagian Penjelasan Warna
            _buildColorMeaning(
              "Biru",
              "Melambangkan kegiatan sensus penduduk yang dilakukan sepuluh tahun sekali pada setiap tahun yang berakhiran angka 0 (nol).",
            ),
            _buildColorMeaning(
              "Hijau",
              "Melambangkan kegiatan sensus pertanian yang dilakukan sepuluh tahun sekali pada setiap tahun yang berakhiran angka 3 (tiga).",
            ),
            _buildColorMeaning(
              "Orange",
              "Melambangkan kegiatan sensus ekonomi yang dilakukan sepuluh tahun sekali pada setiap tahun yang berakhiran angka 6 (enam).",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildColorMeaning(String colorName, String meaning) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            colorName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            meaning,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
