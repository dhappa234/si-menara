import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalisisPage extends StatefulWidget {
  const AnalisisPage({super.key});

  @override
  State<AnalisisPage> createState() => _AnalisisPageState();
}

class _AnalisisPageState extends State<AnalisisPage> {
  final supabase = Supabase.instance.client;

  int totalInstalasi = 0;
  int totalDibuka = 0;
  double pagiPct = 0.0, siangPct = 0.0, malamPct = 0.0;
  bool isLoading = true;
  String _selectedFilter = '30 Hari Terakhir';

  @override
  void initState() {
    super.initState();
    fetchAnalytics(filter: _selectedFilter);
  }

  Future<void> fetchAnalytics({String filter = 'Semua Data'}) async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      var queryBuilder = supabase.from('app_analytics').select('event_name, created_at');

      if (filter == '30 Hari Terakhir') {
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        queryBuilder = queryBuilder.gte('created_at', thirtyDaysAgo.toIso8601String());
      }

      final List<dynamic> allData = await queryBuilder.order('created_at', ascending: true);

      int installCount = 0;
      int openCount = 0;
      int pagi = 0, siang = 0, malam = 0;

      for (var item in allData) {
        String event = item['event_name'] ?? '';
        DateTime date = DateTime.parse(item['created_at']).toLocal();

        if (event == 'app_install') {
          installCount++;
        } else if (event == 'app_open') openCount++;

        if (date.hour >= 4 && date.hour < 12) {
          pagi++;
        } else if (date.hour >= 12 && date.hour < 18) siang++;
        else malam++;
      }

      if (!mounted) return;
      setState(() {
        totalInstalasi = installCount;
        totalDibuka = openCount;
        int totalAktivitas = allData.length;
        if (totalAktivitas > 0) {
          pagiPct = pagi / totalAktivitas;
          siangPct = siang / totalAktivitas;
          malamPct = malam / totalAktivitas;
        } else {
          pagiPct = 0.0; siangPct = 0.0; malamPct = 0.0;
        }
        isLoading = false;
        _selectedFilter = filter;
      });
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF25428F);
    const Color labelGrey = Color(0xFF8E99AF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Analisis Aplikasi",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Color(0xFF1A2138))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => fetchAnalytics(filter: _selectedFilter),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSegmentedFilter(),
              const SizedBox(height: 40),

              // SEKSI INSTALASI
              _buildHeaderRow("INSTALASI APLIKASI", "REAL-TIME", const Color(0xFFDDE7FF), const Color(0xFF3F69FF)),
              const SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$totalInstalasi", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF1A2138))),
                        const Text("TOTAL INSTALASI BARU", style: TextStyle(color: labelGrey, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFFF1F4F9), thickness: 2),
              const SizedBox(height: 40),

              // SEKSI PENGGUNAAN
              _buildHeaderRow("PENGGUNAAN APLIKASI", "+12%", const Color(0xFFE3F9E9), const Color(0xFF31B057)),
              const SizedBox(height: 25),
              Text("$totalDibuka", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF1A2138))),
              const Text("TOTAL APLIKASI DIBUKA", style: TextStyle(color: labelGrey, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.2)),

              const SizedBox(height: 40),
              const Text("DISTRIBUSI WAKTU", style: TextStyle(color: labelGrey, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
              const SizedBox(height: 25),
              _buildModernProgress("PAGI (04:00 - 11:59)", pagiPct, const Color(0xFF5A9CFF)),
              _buildModernProgress("SIANG (12:00 - 17:59)", siangPct, const Color(0xFF2A66FF)),
              _buildModernProgress("MALAM (18:00 - 03:59)", malamPct, const Color(0xFFDDE7FF)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedFilter() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildFilterTab("30 Hari Terakhir", Icons.calendar_today_outlined),
          _buildFilterTab("Semua Data", Icons.history),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, IconData icon) {
    bool isSelected = _selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => fetchAnalytics(filter: label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? const Color(0xFF25428F) : const Color(0xFF8E99AF)),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isSelected ? const Color(0xFF25428F) : const Color(0xFF8E99AF))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String title, String badge, Color badgeBg, Color badgeText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF25428F), letterSpacing: 0.5)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
          child: Text(badge, style: TextStyle(color: badgeText, fontSize: 10, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  Widget _buildModernProgress(String label, double val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1A2138))),
              Text("${(val * 100).toStringAsFixed(1)}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF3F69FF))),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(height: 10, decoration: BoxDecoration(color: const Color(0xFFEEF2F8), borderRadius: BorderRadius.circular(10))),
              FractionallySizedBox(
                widthFactor: val.clamp(0.0, 1.0),
                child: Container(height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}