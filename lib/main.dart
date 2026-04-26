import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// SCREENS
import 'screens/InformasiUmum.dart';
import 'screens/VisidanMisi.dart';
import 'screens/StrukturOrganisasi.dart';
import 'screens/TugasFungsidanKewenangan.dart';
import 'screens/PengolahanData.dart';
import 'screens/Sejarah.dart';
import 'screens/ArtiLogo.dart';
import 'screens/AlamatdanKontak.dart';
import 'screens/ProfilPejabat.dart';
import 'screens/splash_screen.dart';
import 'utils/analytics_service.dart';

// ================= HTTP OVERRIDE =================
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// ================= MAIN =================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  await Supabase.initialize(
    url: 'https://ncgbsjvchefghcibxryi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jZ2JzanZjaGVmZ2hjaWJ4cnlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc2Njc1NjMsImV4cCI6MjA4MzI0MzU2M30.Ix8CZDt0S3cjkL_65F53JFfV60Ke-GHCIw3ApH7pg54',
  );

  // Memanggil fungsi analytic service
  await dotenv.load(fileName: ".env");
  await AnalyticsService.recordAppEntry();

  runApp(const MyApp());
}

// ================= APP ROOT =================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SI MENARA',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      home: const SplashScreen(),
      routes: {
        '/profil_bps_info': (context) => const EditProfilBpsPage(),
        '/infografis': (context) => const InfografisPage(),
      },
    );
  }
}

// ================= PROFIL BPS =================
class EditProfilBpsPage extends StatelessWidget {
  const EditProfilBpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeOrange = Colors.orange;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Profil BPS',
          style: TextStyle(
            color: themeOrange,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMenuItem(
              context,
              'Informasi Umum BPS',
              const InformasiUmumPage(title: 'Informasi Umum'),
              isHeader: true,
            ),
            _buildMenuItem(
              context,
              'Visi dan Misi BPS',
              const VisiDanMisiPage(title: 'Visi dan Misi'),
            ),
            _buildMenuItem(
              context,
              'Struktur Organisasi BPS',
              const StrukturOrganisasiPage(title: 'Struktur Organisasi'),
            ),
            _buildMenuItem(
              context,
              'Tugas, Fungsi, & Kewenangan',
              const TugasFungsidanKewenanganPage(title: 'Tugas & Fungsi'),
            ),
            _buildMenuItem(
              context,
              'Pengolahan Data BPS',
              const PengolahanDataPage(title: 'Pengolahan Data'),
            ),
            _buildMenuItem(
              context,
              'Sejarah BPS',
              const SejarahPage(title: 'Sejarah'),
            ),
            _buildMenuItem(
              context,
              'Arti Logo BPS',
              const ArtiLogoPage(title: 'Arti Logo'),
            ),
            _buildMenuItem(
              context,
              'Alamat dan Kontak BPS',
              const AlamatdanKontakPage(title: 'Alamat & Kontak'),
            ),
            _buildMenuItem(
              context,
              'Profil Pejabat BPS',
              const ProfilPejabatPage(title: 'Profil Pejabat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    Widget target, {
    bool isHeader = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => target),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isHeader ? Colors.orange : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.orange.shade900,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ================= INFOGRAFIS =================
class InfografisPage extends StatefulWidget {
  const InfografisPage({super.key});

  @override
  State<InfografisPage> createState() => _InfografisPageState();
}

class _InfografisPageState extends State<InfografisPage> {
  List data = [];
  bool loading = true;

  final String apiKey = "4357b7707bff6d60ba68cddaa46f32e1";

  @override
  void initState() {
    super.initState();
    fetchInfografis();
  }

  Future<void> fetchInfografis() async {
    try {
      final url = Uri.parse(
        "https://webapi.bps.go.id/v1/api/list/model/infographic/domain/3319/key/$apiKey",
      );

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        final List list = json['data'][1];

        setState(() {
          data = list;
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infografis BPS Kudus"),
        backgroundColor: Colors.orange,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: data.length,
              itemBuilder: (context, i) {
                final item = data[i];

                final title = item['title'] ?? '';
                final download = item['dl'] ?? '';

                return GestureDetector(
                  onTap: () async {
                    if (download.isEmpty) return;

                    final uri = Uri.parse(download);

                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.orange.shade50,
                            child: const Center(
                              child: Icon(
                                Icons.insert_drive_file,
                                size: 60,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
