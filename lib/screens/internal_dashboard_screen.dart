import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/survey_model.dart';

class InternalDashboardScreen extends StatelessWidget {
  const InternalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Logika Perhitungan Data secara Real-time
    int count5 = globalSurveyRepo.where((e) => e.rating == 5).length;
    int count4 = globalSurveyRepo.where((e) => e.rating == 4).length;
    int count3 = globalSurveyRepo.where((e) => e.rating == 3).length;
    int countLow = globalSurveyRepo.where((e) => e.rating <= 2).length;

    int totalResponden = globalSurveyRepo.length;
    double avgRating = SurveyHelper.getAverageRating();
    Map<String, double> monthlyAverages = SurveyHelper.getMonthlyAverages();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text("Monitoring Kepuasan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- KARTU RINGKASAN STATISTIK ---
          Row(
            children: [
              _buildModernSummaryCard("Responden", totalResponden.toString(),
                  Icons.people_alt_rounded, Colors.blue),
              const SizedBox(width: 12),
              _buildModernSummaryCard(
                  "Avg Rating",
                  avgRating.toStringAsFixed(1),
                  Icons.star_rounded,
                  Colors.orange),
            ],
          ),
          const SizedBox(height: 20),

          // --- SEKSI 1: GRAFIK PIE REAL-TIME ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Analisis Distribusi (Real-time)",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: totalResponden == 0
                      ? const Center(child: Text("Belum ada data survei masuk"))
                      : PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                            sections: [
                              _buildPieSection(
                                  count5.toDouble(), Colors.green, "5★"),
                              _buildPieSection(
                                  count4.toDouble(), Colors.blue, "4★"),
                              _buildPieSection(
                                  count3.toDouble(), Colors.orange, "3★"),
                              _buildPieSection(
                                  countLow.toDouble(), Colors.red, "1-2★"),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- SEKSI 2: REKAP BULANAN ---
          const Text("Performa Bulanan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (monthlyAverages.isEmpty)
            const Center(child: Text("Belum ada rekap bulanan."))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: monthlyAverages.entries.map((entry) {
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(entry.value.toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: SurveyHelper.getColorForRating(
                                    entry.value))),
                        const Text("Rating Rata-rata",
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 24),

          // --- SEKSI 3: DAFTAR SARAN TERBARU ---
          const Text("Daftar Masukan User",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: globalSurveyRepo.length,
            itemBuilder: (context, index) {
              final item = globalSurveyRepo.reversed.toList()[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          SurveyHelper.getColorForRating(item.rating)
                              .withOpacity(0.1),
                      child: Text(item.rating.toInt().toString(),
                          style: TextStyle(
                              color:
                                  SurveyHelper.getColorForRating(item.rating),
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              item.saran.isEmpty ? "(Tanpa saran)" : item.saran,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text(
                              "${item.date.day}/${item.date.month}/${item.date.year}",
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Potongan Pie Chart
  PieChartSectionData _buildPieSection(
      double value, Color color, String title) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: title,
      radius: 50,
      titleStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  // Widget Helper untuk Kartu Ringkasan
  Widget _buildModernSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
