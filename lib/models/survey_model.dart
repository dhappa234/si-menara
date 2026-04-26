import 'package:flutter/material.dart';

class SurveyData {
  final double rating;
  final String saran;
  final DateTime date;

  SurveyData({
    required this.rating,
    required this.saran,
    required this.date,
  });
}
List<SurveyData> globalSurveyRepo = [
  SurveyData(
    rating: 5,
    saran: "Aplikasi sangat informatif dan data BPS Kudus sangat lengkap.",
    date: DateTime(2025, 12, 15),
  ),
  SurveyData(
    rating: 4,
    saran: "Tampilan sudah bagus, kalau bisa ditambah grafik tren tahunan.",
    date: DateTime(2025, 12, 28),
  ),
  SurveyData(
    rating: 3,
    saran: "Loading data terkadang agak lama.",
    date: DateTime(2026, 01, 10),
  ),
];
class SurveyHelper {
  static double getAverageRating() {
    if (globalSurveyRepo.isEmpty) return 0.0;
    double total = globalSurveyRepo.fold(0.0, (sum, item) => sum + item.rating);
    return total / globalSurveyRepo.length;
  }

  static Map<String, double> getMonthlyAverages() {
    Map<String, List<double>> groupedData = {};
    for (var data in globalSurveyRepo) {
      String monthKey = "${_getMonthName(data.date.month)} ${data.date.year}";
      groupedData.putIfAbsent(monthKey, () => []).add(data.rating);
    }
    Map<String, double> averages = {};
    groupedData.forEach((key, ratings) {
      double sum = ratings.reduce((a, b) => a + b);
      averages[key] = sum / ratings.length;
    });
    return averages;
  }

  static String _getMonthName(int month) {
    const months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
    return months[month - 1];
  }
  static Color getColorForRating(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.blue;
    if (rating >= 2.5) return Colors.orange;
    return Colors.red;
  }
}