import 'package:flutter/material.dart';
import 'package:simenara/services/analisis_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'surveypage.dart';
import '../services/auth_wrapper.dart';
import '../main.dart';
import '../services/kelola_permintaan.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    const Color themeOrange = Color(0xFFFF9800);
    const Color scaffoldBg = Color(0xFFF8F9FE);
    const Color textColor = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil Admin',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ================= HEADER PROFIL =================
            _buildHeader(themeOrange, textColor),

            const SizedBox(height: 40),

            // ================= BAGIAN PENGATURAN =================
            _buildSectionTitle('PENGATURAN'),
            _buildMenuContainer([
              _buildInteractiveMenuItem(
                Icons.bar_chart_rounded,
                'Kelola Survey',
                const Color(0xFF6366F1), // Warna Ungu/Biru sesuai gambar
                const Color(0xFFEEF2FF),
                    () => _navigate(const HasilSurveyPage()),
              ),
              _buildDivider(),
              _buildInteractiveMenuItem(
                Icons.assignment_rounded,
                'Kelola Permintaan Data',
                const Color(0xFFA855F7), // Warna Violet
                const Color(0xFFF5F3FF),
                    () => _navigate(const KelolaPermintaanPage()),
              ),
              _buildDivider(),
              _buildInteractiveMenuItem(
                Icons.business_center_rounded,
                'Profil Informasi BPS',
                const Color(0xFF3B82F6), // Warna Biru
                const Color(0xFFEFF6FF),
                    () => _navigate(const EditProfilBpsPage()),
              ),
              _buildDivider(),
              _buildInteractiveMenuItem(
                Icons.show_chart_rounded,
                'Analisis Aplikasi',
                const Color(0xFF10B981), // Warna Hijau sesuai gambar
                const Color(0xFFECFDF5),
                    () => _navigate(const AnalisisPage()),
              ),
            ]),

            const SizedBox(height: 30),

            // ================= BAGIAN AKUN =================
            _buildSectionTitle('AKUN'),
            _buildMenuContainer([
              _buildInteractiveMenuItem(
                Icons.logout_rounded,
                'Logout',
                const Color(0xFFEF4444),
                const Color(0xFFFEF2F2),
                    () => _showLogoutDialog(context),
                isLogout: true,
              ),
            ]),

            const SizedBox(height: 40),
            Text(
              "Versi Aplikasi 1.0",
              style: TextStyle(color: const Color(0xFF64748B).withOpacity(0.6), fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              "© 2026 BPS Kabupaten Kudus",
              style: TextStyle(color: const Color(0xFF64748B).withOpacity(0.4), fontSize: 11),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Header Profil sesuai Gambar ---
  Widget _buildHeader(Color themeColor, Color textColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFF1F5F9),
            // Menggunakan gambar dari asset profil lama sesuai instruksi
            backgroundImage: AssetImage('assets/icons/profile.png'),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'BPS Kabupaten Kudus',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user?.email ?? "bps3319@bps.go.id",
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFFCD34D).withOpacity(0.5)),
          ),
          child: const Text(
            'ADMIN',
            style: TextStyle(
              color: Color(0xFFD97706),
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInteractiveMenuItem(
      IconData icon,
      String title,
      Color iconColor,
      Color bgColor,
      VoidCallback onTap, {
        bool isLogout = false,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF334155),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: const Color(0xFF64748B).withOpacity(0.3),
        size: 14,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 75,
      endIndent: 20,
      color: const Color(0xFF64748B).withOpacity(0.05),
    );
  }

  void _navigate(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthWrapper()),
                      (route) => false,
                );
              }
            },
            child: const Text('Ya, Keluar', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}