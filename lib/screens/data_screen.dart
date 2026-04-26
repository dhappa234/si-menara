import 'package:flutter/material.dart';
import '../services/bps_service.dart';
import 'detail_stat_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Map<String, dynamic>> _allData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = true;
  bool? _isConnectionOk;
  final TextEditingController _searchController = TextEditingController();

  // --- DAFTAR LABEL MANUAL ---
  final Map<int, String> _varLabels = {
    130: "Rasio Jenis Kelamin",
    43: "Jumlah Penduduk Menurut Jenis Kelamin",
    145: "Tingkat Partisipasi Angkatan Kerja (TPAK)",
    30: "Tingkat Pengangguran Terbuka (TPT)",
    95: "Penduduk Miskin di Kabupaten Kudus",
    121: "Angka Partisipasi Kasar Kabupaten Kudus",
    120: "Angka Partisipasi Murni Kabupaten Kudus",
    227: "IPG - Usia Harapan Hidup (UHH)",
    33: "Indeks Pembangunan Manusia (IPM)",
    225: "IPG - Pengeluaran Perkapita yang Disesuaikan Menurut Jenis Kelamin",
    118: "[Seri 2010] - Laju Indeks Harga Implisit PDRB Menurut Pengeluaran",
    207: "Laju Pertumbuhan (y-on-y) Produk Domestik Regional Bruto (PDRB)",
    148: "PDRB Atas Dasar Harga Berlaku Menurut Lapangan Usaha",
    1: "Inflasi Bulanan Kabupaten Kudus",
    188: "Jumlah Perjalanan Wisatawan Nusantara",
    45: "Produksi Padi Kabupaten Kudus",
  };

  String _selectedCategory = "Statistik Demografi & Sosial";

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    setState(() => _isLoading = true);
    bool conn = await BpsService.checkConnection();
    if (mounted) setState(() => _isConnectionOk = conn);
    if (conn) {
      await _fetchDataByCategory(_selectedCategory);
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- FUNGSI FETCH DENGAN TAHUN TERBARU DINAMIS ---
  Future<void> _fetchDataByCategory(String category) async {
    if (mounted) setState(() => _isLoading = true);

    List<int> ids;
    if (category == "Statistik Ekonomi") {
      ids = BpsService.getEkonomiVarIds();
    } else if (category == "Statistik Pertanian") {
      ids = BpsService.getPertanianVarIds();
    } else {
      ids = BpsService.getSosialVarIds();
    }

    try {
      // Mengambil daftar tahun tersedia untuk setiap ID secara paralel
      final List<List<int>> yearsResults = await Future.wait(
          ids.map((id) => BpsService.fetchAvailableYears(id)));

      List<Map<String, dynamic>> loadedData = [];
      for (int i = 0; i < ids.length; i++) {
        int currentId = ids[i];
        List<int> availableYears = yearsResults[i];

        // Ambil tahun pertama (paling terbaru) dari hasil API
        String latestYear =
            availableYears.isNotEmpty ? availableYears.first.toString() : "-";

        loadedData.add({
          'var_id': currentId,
          'title': _varLabels[currentId] ?? "Variabel $currentId",
          'latest_year': latestYear,
          'subcsa_name': category
        });
      }

      if (mounted) {
        setState(() {
          _allData = loadedData;
          _filteredData = loadedData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error load category list: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _allData.where((item) {
        final title = item['title'].toString().toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text('Data Strategis',
                style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            actions: [
              IconButton(
                  onPressed: () => _fetchDataByCategory(_selectedCategory),
                  icon: const Icon(Icons.refresh_rounded, color: Colors.orange))
            ],
          ),

          // Header Search & Filter
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildConnectionStatus(),
                _buildSearchAndFilter(),
              ],
            ),
          ),

          // List Data Statistik
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: _isLoading
                ? const SliverFillRemaining(
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.orange)))
                : _buildDataList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    if (_isConnectionOk == false) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.red, size: 16),
            SizedBox(width: 8),
            Text("Gagal terhubung ke API BPS",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                hintText: "Cari data statistik...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: Colors.orange),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                "Statistik Demografi & Sosial",
                "Statistik Ekonomi",
                "Statistik Pertanian"
              ].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() => _selectedCategory = cat);
                        _fetchDataByCategory(cat);
                      }
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                    elevation: 0,
                    pressElevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: isSelected
                              ? Colors.orange
                              : Colors.grey.shade200),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDataList() {
    if (_filteredData.isEmpty) {
      return SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("Data tidak ditemukan",
                style: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = _filteredData[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child:
                    const Icon(Icons.analytics_rounded, color: Colors.orange),
              ),
              title: Text(
                item['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B)),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text("ID: ${item['var_id']}",
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B))),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.calendar_today_rounded,
                        size: 12, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text("Terbaru: ${item['latest_year']}",
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFFCBD5E1)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailDataScreen(
                      varId: item['var_id'],
                      title: item['title'],
                    ),
                  ),
                );
              },
            ),
          );
        },
        childCount: _filteredData.length,
      ),
    );
  }
}
