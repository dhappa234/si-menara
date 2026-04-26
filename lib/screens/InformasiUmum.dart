import 'package:flutter/material.dart';

class InformasiUmumPage extends StatelessWidget {
  final String title;
  const InformasiUmumPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.orange,
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("BPS Kabupaten Kudus"),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Informasi Umum BPS",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              "Badan Pusat Statistik adalah Lembaga Pemerintah Non Kementerian yang bertanggung jawab langsung kepada Presiden. Sebelumnya, BPS merupakan Biro Pusat Statistik, yang dibentuk berdasarkan UU Nomor 6 Tahun 1960 tentang Sensus dan UU Nomer 7 Tahun 1960 tentang Statistik. Sebagai pengganti kedua UU tersebut ditetapkan UU Nomor 16 Tahun 1997 tentang Statistik. Berdasarkan UU ini yang ditindaklanjuti dengan peraturan perundangan dibawahnya, secara formal nama Biro Pusat Statistik diganti menjadi Badan Pusat Statistik.",

              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 15),

            const Text(
              "Materi yang merupakan muatan baru dalam UU Nomor 16 Tahun 1997, antara lain :.",

              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 15),

            _buildBulletPoint(
              "Jenis statistik berdasarkan tujuan pemanfaatannya terdiri atas statistik dasar yang sepenuhnya diselenggarakan oleh BPS, statistik sektoral yang dilaksanakan oleh instansi Pemerintah secara mandiri atau bersama dengan BPS, serta statistik khusus yang diselenggarakan oleh lembaga, organisasi, perorangan, dan atau unsur masyarakat lainnya secara mandiri atau bersama dengan BPS.",
            ),
            _buildBulletPoint(
              "Hasil statistik yang diselenggarakan oleh BPS diumumkan dalam Berita Resmi Statistik (BRS) secara teratur dan transparan agar masyarakat dengan mudah mengetahui dan atau mendapatkan data yang diperlukan.",
            ),
            _buildBulletPoint(
              "Sistem Statistik Nasional yang andal, efektif, dan efisien.",
            ),
            _buildBulletPoint(
              "Dibentuknya Forum Masyarakat Statistik sebagai wadah untuk menampung aspirasi masyarakat statistik, yang bertugas memberikan saran dan pertimbangan kepada BPS.",
            ),
            const Text(
              "Berdasarkan undang-undang yang telah disebutkan di atas, peranan yang harus dijalankan oleh BPS adalah sebagai berikut :  ",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 15),

            _buildBulletPoint(
              "Menyediakan kebutuhan data bagi pemerintah dan masyarakat. Data ini didapatkan dari sensus atau survey yang dilakukan sendiri dan juga dari departemen atau lembaga pemerintahan lainnya sebagai data sekunder",
            ),
            _buildBulletPoint(
              "Membantu kegiatan statistik di kementrian, lembaga pemerintah atau institusi lainnya, dalam membangun sistem perstatistikan nasional.",
            ),
            _buildBulletPoint(
              "Mengembangkan dan mempromosikan standar teknik dan metodologi statistik, dan menyediakan pelayanan pada bidang pendidikan dan pelatihan statistik.",
            ),
            _buildBulletPoint(
              "Membangun kerjasama dengan institusi internasional dan negara lain untuk kepentingan perkembangan statistik Indonesia.",
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi ini HARUS di dalam class DetailInfoPage (sebelum tanda kurung terakhir)
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
