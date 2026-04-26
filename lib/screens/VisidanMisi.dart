import 'package:flutter/material.dart';

class VisiDanMisiPage extends StatelessWidget {
  final String title;
  const VisiDanMisiPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const Color bpsBlue = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: bpsBlue,
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
                borderRadius: BorderRadius.circular(
                  4,
                ),
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

            // Judul Halaman (Visi dan Misi BPS)
            const Text(
              "Visi dan Misi BPS",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: bpsBlue,
              ),
            ),
            const SizedBox(height: 20),

            // Paragraf Visi
            const Text(
              "Dengan mempertimbangkan capaian kinerja, memperhatikan aspirasi masyarakat, potensi dan permasalahan, serta mewujudkan Visi Presiden dan Wakil Presiden maka visi Badan Pusat Statistik untuk tahun 2025-2029 adalah:",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 15),
            ),
            const SizedBox(height: 20),

            const Center(
              child: Text(
                "“Lembaga yang Independen, Tepercaya, dan Berperan Aktif dalam Mendukung Perumusan Kebijakan Berbasis Data Bersama Indonesia Maju Menuju Indonesia Emas 2045”",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Penjelasan Visi
            const Text(
              "Dalam visi yang baru tersebut BPS menetapkan visi yang berlandaskan prinsip independensi, kepercayaan publik, peran aktif, serta dukungan penuh terhadap kebijakan berbasis data. Sebagai lembaga yang menjunjung tinggi objektivitas dan tidak memihak, BPS memastikan seluruh proses statistik berjalan netral dan bebas dari intervensi, sehingga mampu mewujudkan Sistem Statistik Nasional yang andal.",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 15),
            ),
            const SizedBox(height: 15),
            const Text(
              "Dalam menjaga kepercayaan publik, BPS berkomitmen menyediakan data yang akurat, mutakhir, dan berkualitas tinggi melalui metode yang terstandar serta proses yang transparan. BPS juga mengambil peran aktif dengan berkolaborasi dan berkontribusi bagi pembangunan nasional, baik melalui penyusunan statistik maupun pendampingan kepada kementerian/lembaga dan pemerintah daerah dalam menghasilkan data yang berkualitas.",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 15),
            ),
            const SizedBox(height: 15),
            const Text(
              "Selain itu, BPS menjadi pilar penting dalam mendorong kebijakan berbasis data, memastikan setiap keputusan pemerintah memiliki landasan informasi yang kuat dan dapat dipertanggungjawabkan. Seluruh upaya ini sejalan dengan visi Presiden untuk menghadirkan pemerintahan yang efektif, efisien, dan responsif terhadap kebutuhan masyarakat melalui pemanfaatan data yang kredibel.",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 15),
            ),
            const SizedBox(height: 15),

            // Bagian Misi
            const Text(
              "Misi BPS dirumuskan dengan memperhatikan fungsi dan kewenangan BPS. Selaras dengan arah kebijakan di dalam RPJPN 2025-2045, RPJMN 2025-2029, serta Visi Presiden dan Wakil Presiden 2024-2029 yaitu “Bersama Indonesia Maju Menuju Indonesia Emas 2045” dengan uraian sebagai berikut:",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 15),
            ),
            const SizedBox(height: 15),

            // Daftar Misi dengan Penomoran Angka
            _buildNumberItem(
              "1",
              "Menyediakan Data Statistik Berkualitas dan Insight untuk Perumusan Kebijakan dan Pengambilan Keputusan",
            ),
            _buildNumberItem(
              "2",
              "Menguatkan Kepemimpinan BPS dalam penyelenggaraan Sistem Statistik Nasional (SSN)",
            ),
            _buildNumberItem(
              "3",
              "Menguatkan kapasitas kelembagaan statistik yang efektif dan efisien",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget untuk List Berangka (1, 2, 3)
  Widget _buildNumberItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number. ", style: const TextStyle(fontSize: 15, height: 1.5)),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.5, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
