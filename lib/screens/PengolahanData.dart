import 'package:flutter/material.dart';

class PengolahanDataPage extends StatelessWidget {
  final String title;

  const PengolahanDataPage({super.key, required this.title});

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
            // --- DROPDOWN HEADER ---
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

            // --- JUDUL KONTEN ---
            const Text(
              "Pengolahan Data BPS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleBlue,
              ),
            ),
            const SizedBox(height: 20),

            // --- ISI PARAGRAF (Sesuai Gambar) ---
            _buildParagraph(
              "Tahap pengolahan data sangat menentukan seberapa jauh tingkat keakuratan dan ketepatan data statistik yang dihasilkan. BPS merupakan instansi perintis dalam penggunaan komputer karena telah memulai menggunakannya sejak sekitar 1960. Sebelum menggunakan komputer, BPS menggunakan kalkulator dan alat hitung sipoa dalam mengolah data.",
            ),

            _buildParagraph(
              "Teknologi komputer yang diterapkan di BPS selalu disesuaikan dengan perkembangan teknologi informasi dan juga mengacu kepada kebutuhan. Personal komputer yang secara umum lebih murah dan efisien telah dicoba digunakan untuk menggantikan mainframe. Sejak 1980-an, personal komputer telah digunakan di seluruh kantor BPS provinsi, diikuti dengan penggunaan komputer di seluruh BPS kabupaten dan kota sejak 1992.",
            ),

            _buildParagraph(
              "Dengan menggunakan personal komputer, kantor statistik di daerah dapat segera memproses pengolahan data, yang merupakan rangkaian kegiatan yang dimulai dari pengumpulan data, kemudian memasukkan data mentah ke dalam komputer dan selanjutnya data tersebut dikirim ke BPS pusat untuk diolah menjadi data nasional.",
            ),

            _buildParagraph(
              "Pengolahan data menggunakan personal komputer telah lama menjadi contoh pengolahan yang diterapkan oleh direktorat teknis di BPS pusat, terutama jika direktorat tersebut harus mempublikasikan hasil yang diperoleh dari survei yang diselenggarakan.",
            ),

            _buildParagraph(
              "Pengolahan data Sensus Penduduk tahun 2000 telah menggunakan mesin scanner, tujuannya untuk mempercepat kegiatan pengolahan data. Efek positif dari penggunaan komputer oleh direktorat teknis yaitu selain lebih cepat, juga dapat memotivasi pegawai yang terlibat turut bertanggung jawab untuk menghasilkan sebanyak mungkin data statistik dan indikator secara tepat waktu dan akurat dibanding sebelumnya. Selain itu, penggunaan komputer sangat mendukung BPS dalam menghasilkan berbagai data statistik dan indikator-indikator yang rumit seperti kemiskinan, Input-Output (I-O) table, Social Accounting Matrix (SAM), dan berbagai macam indeks komposit dalam waktu yang relatif singkat.",
            ),

            _buildParagraph(
              "Pada 1993, BPS mulai mengembangkan sebuah sistem informasi statistik secara geografis khususnya untuk pengolahan data wilayah sampai unit administrasi yang terkecil yang telah mulai dibuat secara manual sejak 1970. Data wilayah ini dibuat khususnya untuk menyajikan karakteristik daerah yang menonjol yang diperlukan oleh para perumus kebijakan dalam perencanaan pembangunan.",
            ),

            _buildParagraph(
              "Dalam mengolah data, BPS juga telah mengembangkan berbagai program aplikasi untuk data entry, editing, validasi, tabulasi dan analisis dengan menggunakan berbagai macam bahasa dan paket komputer. BPS bertanggung jawab untuk mengembangkan berbagai perangkat lunak komputer serta mentransfer pengetahuan dan keahliannya kepada staf BPS daerah.",
            ),

            _buildParagraph(
              "Pembangunan infrastruktur teknologi informasi di BPS didasarkan pada tujuan yang ingin dicapai yaitu mengikuti perkembangan permintaan dan kebutuhan dalam pengolahan data statistik; melakukan pembaharuan/inovasi dalam hal metode kerja yang lebih baik serta memberikan kemudahan kepada publik dalam mendapatkan informasi statistik.",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk membuat paragraf yang rapi
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
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
