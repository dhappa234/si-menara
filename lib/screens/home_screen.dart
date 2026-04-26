import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data_screen.dart';
import 'infografis_category_screen.dart';
import 'survey_screen.dart';
import 'konsultasi.dart';
import 'permintaan_data_screen.dart';

import '../services/auth_wrapper.dart';
import '../main.dart';

// ================== FUNGSI BUKA LINK PENGADUAN ==================
Future<void> _openPengaduan() async {
  final Uri url = Uri.parse(
    'https://docs.google.com/forms/d/e/1FAIpQLSdwy2R2TP5lVufppEF3mnYvaM_aA0FCJgxKJjUXCUe662QGWw/viewform',
  );

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Tidak bisa membuka link: $url';
  }
}

// ================== HOME SCREEN ==================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/logo_bps.png', width: 32),
                      const SizedBox(width: 8),
                      Text(
                        'BPS Kabupaten Kudus',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  // ADMIN / LOGIN
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AuthWrapper(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFFFFE0B2),
                            child: Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Admin",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ================= LAYANAN UTAMA =================
              Text(
                'Layanan Utama',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D1B3E),
                ),
              ),

              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1.2,
                children: [
                  _MenuCard(
                    icon: Icons.bar_chart_rounded,
                    label: 'Data Strategis',
                    color: const Color(0xFFFF6D00),
                    bgColor: const Color(0xFFFFF7ED),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DataScreen())),
                  ),
                  _MenuCard(
                    icon: Icons.headset_mic_rounded,
                    label: 'Layanan Konsultasi',
                    color: const Color(0xFF00C853),
                    bgColor: const Color(0xFFF0FFF4),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                  ),
                  _MenuCard(
                    icon: Icons.assignment_outlined,
                    label: 'Permintaan Data',
                    color: const Color(0xFF9C27B0),
                    bgColor: const Color(0xFFFAF5FF),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PermintaanDataScreen())),
                  ),
                  const _MenuCard(
                    icon: Icons.warning_rounded,
                    label: 'Layanan Pengaduan',
                    color: Color(0xFFEF5350),
                    bgColor: Color(0xFFFFF5F5),
                    onTap: _openPengaduan,
                  ),
                  _MenuCard(
                    icon: Icons.thumb_up_alt_rounded,
                    label: 'Survei Kepuasan',
                    color: const Color(0xFF2979FF),
                    bgColor: const Color(0xFFF0F7FF),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SurveyScreen())),
                  ),
                  _MenuCard(
                    icon: Icons.info_rounded,
                    label: 'Tentang BPS Kudus',
                    color: const Color(0xFF546E7A),
                    bgColor: const Color(0xFFF8FAFC),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilBpsPage())),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ================= INFOGRAFIS =================
              Text(
                'Eksplorasi Infografis',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pilih kategori untuk melihat visualisasi data terbaru.',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),

              const SizedBox(height: 20),

              // LIST INFOGRAFIS SESUAI GAMBAR
              _InfografisListTile(
                title: 'Infografis Sosial',
                subtitle: 'Kependudukan, Kemiskinan, & IPM',
                icon: Icons.people_alt_rounded,
                color: const Color(0xFF2979FF),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfografisCategoryScreen(category: '1'))),
              ),
              _InfografisListTile(
                title: 'Infografis Ekonomi',
                subtitle: 'Pertumbuhan PDRB, Inflasi, & Wisatawan',
                icon: Icons.trending_up_rounded,
                color: const Color(0xFFFF6D00),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfografisCategoryScreen(category: '2'))),
              ),
              _InfografisListTile(
                title: 'Infografis Pertanian',
                subtitle: 'Produksi Padi',
                icon: Icons.agriculture_rounded,
                color: const Color(0xFF00C853),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InfografisCategoryScreen(category: '3'))),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk Kartu Menu Utama (Grid)
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3142),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk List Infografis (Horizontal Card)
class _InfografisListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _InfografisListTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF0F0F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}