import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/bps_service.dart';

class DetailDataScreen extends StatefulWidget {
  final int varId;
  final String title;

  const DetailDataScreen({
    super.key,
    required this.varId,
    required this.title,
  });

  @override
  State<DetailDataScreen> createState() => _DetailDataScreenState();
}

class _DetailDataScreenState extends State<DetailDataScreen>
    with TickerProviderStateMixin {
  Future<Map<String, dynamic>>? _dataFuture;
  int _selectedYear = 2023;
  List<int> _availableYears = [];
  bool _isLoadingYears = true;
  String _dynamicTitle = "";
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _dynamicTitle = widget.title;
    _initScreen();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _initScreen() async {
    setState(() => _isLoadingYears = true);
    List<int> years = await BpsService.fetchAvailableYears(widget.varId);

    if (mounted) {
      setState(() {
        if (years.isNotEmpty) {
          years.sort((a, b) => b.compareTo(a));
          _availableYears = years;
          _selectedYear = _availableYears.first;
        } else {
          _availableYears = [2024, 2023, 2022];
          _selectedYear = 2023;
        }
        _isLoadingYears = false;

        _tabController = TabController(length: 2, vsync: this);
      });
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      _dataFuture =
          BpsService.fetchStatData(varId: widget.varId, year: _selectedYear);
    });
  }

  String _formatValue(String value, String unit) {
    if (value == "-" || value.isEmpty || value == "null") return "-";

    double? numValue = double.tryParse(value.replaceAll(',', '.'));
    if (numValue == null) return value;

    String finalResult;

    if (numValue == numValue.truncateToDouble()) {
      finalResult = numValue.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    } else {
      String formatted = numValue.toStringAsFixed(2);
      List<String> parts = formatted.split('.');
      parts[0] = parts[0].replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
      finalResult = parts.join(',');
    }

    String unitLower = unit.toLowerCase();
    if (unitLower.contains("persen") || unitLower.contains("%")) {
      return "$finalResult%";
    }
    if (unitLower.contains("rupiah") || unitLower.startsWith("rp")) {
      return "Rp $finalResult";
    }
    return finalResult;
  }

  void _showYearPicker() {
    if (_availableYears.isEmpty) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        child: Column(
          children: [
            Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10))),
            const Text("Pilih Tahun Data",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _availableYears.length,
                itemBuilder: (context, index) {
                  final year = _availableYears[index];
                  final isSelected = year == _selectedYear;
                  return ListTile(
                    title: Text(year.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                                isSelected ? Colors.orange : Colors.black87)),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.orange)
                        : const SizedBox(width: 24),
                    onTap: () {
                      setState(() => _selectedYear = year);
                      _loadData();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(_dynamicTitle,
            maxLines: 2,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        bottom: _tabController != null
            ? TabBar(
                controller: _tabController,
                indicatorColor: Colors.orange,
                tabs: const [
                  Tab(text: "Tabel"),
                  Tab(text: "Chart"),
                ],
              )
            : null,
        actions: [
          if (!_isLoadingYears)
            IconButton(
                icon: const Icon(Icons.calendar_month_rounded,
                    color: Colors.orange),
                onPressed: _showYearPicker)
        ],
      ),
      body: _isLoadingYears || _tabController == null
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : FutureBuilder<Map<String, dynamic>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.orange));
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return _buildErrorState();
                }

                final apiData = snapshot.data!;
                if (apiData['title'] != null &&
                    apiData['title'] != _dynamicTitle) {
                  Future.microtask(
                      () => setState(() => _dynamicTitle = apiData['title']));
                }

                return TabBarView(
                  controller: _tabController!,
                  children: [
                    Column(
                      children: [
                        _buildMetadataPanel(
                            apiData['unit'] ?? "-", _selectedYear.toString()),
                        const SizedBox(
                          height: 12,
                        ),
                        Expanded(child: _buildDetailTable(apiData)),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.all(12),
                        child: _buildChartView(apiData)),
                  ],
                );
              },
            ),
    );
  }

  // ===================== CHART =====================
  Widget _buildChartView(Map<String, dynamic> apiData) {
    final List columns = apiData['columns'] ?? [];
    final List rows = apiData['rows'] ?? [];

    if (rows.isEmpty || columns.isEmpty) return _buildErrorState();

    List<String> xLabels =
        rows.map((e) => e['label_wilayah'].toString()).toList();
    List<double> yValues = rows
        .map((e) =>
            double.tryParse(
                e[columns[0]['label']].toString().replaceAll(',', '.')) ??
            0)
        .toList();

    // Lebar chart = 200% layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final double forcedWidth = screenWidth * 1.5;

    // Lebar tiap bar menyesuaikan jumlah data agar proporsional
    final double barWidth = forcedWidth / (xLabels.length * 1.5);
    final double spaceBetweenBars = barWidth * 0.3;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: forcedWidth + 100,
        alignment: Alignment.center, // tetap di tengah
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 28),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (yValues.isNotEmpty
                  ? yValues.reduce((a, b) => a > b ? a : b) * 1.2
                  : 10),
              barGroups: List.generate(xLabels.length, (i) {
                return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                          toY: yValues[i],
                          color: Colors.orange,
                          width: barWidth,
                          borderRadius: BorderRadius.circular(4))
                    ],
                    barsSpace: spaceBetweenBars);
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= xLabels.length) {
                      return const SizedBox();
                    }
                    return SizedBox(
                      width: barWidth + 20,
                      child: Transform.rotate(
                        angle: -0.25,
                        child: Text(
                          xLabels[index],
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  reservedSize: barWidth + 20,
                )),
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 55)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  // ===================== METADATA =====================
  Widget _buildMetadataPanel(String unit, String year) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF334155)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildMetaItem(Icons.straighten_rounded, "Satuan",
              unit.isEmpty || unit == "-" ? "Jiwa/Psn" : unit),
          Container(
              width: 1,
              height: 30,
              color: Colors.white12,
              margin: const EdgeInsets.symmetric(horizontal: 20)),
          _buildMetaItem(Icons.event_note_rounded, "Tahun Data", year),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 10)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
        ],
      ),
    );
  }

  // ===================== TABLE =====================
  Widget _buildDetailTable(Map<String, dynamic> apiData) {
    final List columns = apiData['columns'] ?? [];
    final List rows = apiData['rows'] ?? [];

    if (rows.isEmpty) return _buildErrorState();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
          child: DataTable(
            headingRowColor:
                WidgetStateProperty.all(Colors.orange.withOpacity(0.05)),
            columns: [
              const DataColumn(
                  label: Text('Wilayah',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              ...columns
                  .map((col) => DataColumn(
                          label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(col['label'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      )))
                  ,
            ],
            rows: rows
                .map((row) => DataRow(cells: [
                      DataCell(Text(row['label_wilayah'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12))),
                      ...columns
                          .map((col) => DataCell(
                                Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        _formatValue(
                                            row[col['label']].toString(),
                                            apiData['unit'] ?? ""),
                                        style: const TextStyle(fontSize: 12))),
                              ))
                          ,
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }

  // ===================== ERROR =====================
  Widget _buildErrorState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey.shade300),
      const SizedBox(height: 16),
      const Text("Data tidak tersedia dari API BPS untuk tahun ini"),
      TextButton(
          onPressed: _showYearPicker,
          child: const Text("Coba Tahun Lain",
              style: TextStyle(color: Colors.orange))),
    ]));
  }
}
