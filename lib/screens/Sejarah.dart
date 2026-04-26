import 'package:flutter/material.dart';

class SejarahPage extends StatelessWidget {
  final String title;
  const SejarahPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const Color bpsBlue = Color(0xFFF7941D);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "BPS Kabupaten Kudus",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 1),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sejarah BPS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: bpsBlue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildParagraph(
                    "Pemerintahan Hindia Belanda, Februari 1920 Kantor Statistik untuk pertama kali didirikan oleh Direktur   Pertanian   dan   Perdagangan (Directeur van Landbouw Nijverheid en Handel) dan berkedudukan di Bogor. Pada bulan Maret 1923 dibentuk suatu komisi yang bernama Komisi untuk Statistik yang anggotanya   merupakan   wakil-wakil   dari tiap-tiap departemen. Komisi tersebut diberi tugas   merencanakan   tindakan   yang mengarah   sejauh   mungkin   pencapaian kesatuan dalam kegiatan bidang statistik di Indonesia. Pada tanggal 24 September 1924 nama lembaga tersebut diganti dengan nama Centraal Kantoor voor de Statistiek (CKS) atau  Kantor Pusat Statistik dan dipindahkan ke Jakarta.",
                  ),
                  _buildParagraph(
                    "Pada   bulan   Juni   1942   Pemerintah Jepang   mengaktifkan   kembali   kegiatan statistik yang difokuskan untuk memenuhi kebutuhan   perang/militer.   CKS   diganti namanya   menjadi  Shomubu   Chosasitsu Gunseikanbu.",
                  ),
                  _buildParagraph(
                    "26 September 1960 Pemerintah RI memberlakukan UU No 7 tahun 1960 tentang Statistik sebagai pengganti Statistiek Ordonantie 1934 à kelahiran UU tersebut merupakan titik awal perjalanan BPS dalam mengisi kemerdekaan di bidang statistik yang selama ini diatur berdasarkan sistem perundang-undangan kolonial. UU tersebut secara rinci mengatur penyelenggaraan statistik dan organisasi BPS.",
                  ),
                  _buildParagraph(
                    "Pada Agustus 1996, Soeharto, menetapkan tanggal diundangkannya UU No 7 tahun 1960 tentang Statistik tersebut sebagai 'Hari Statistik' yang dilaksanakan secara nasional.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat paragraf
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6,
          color: Colors.black87,
        ),
      ),
    );
  }
}
