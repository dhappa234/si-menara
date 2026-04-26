import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SurveyData {
  final double rating;
  final String saran;
  final DateTime date;

  SurveyData({required this.rating, required this.saran, required this.date});

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "saran": saran,
        "created_at": date.toIso8601String(),
      };
}

List<SurveyData> globalSurveyRepo = [];
class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}
class _SurveyScreenState extends State<SurveyScreen> {
  double _rating = 0;
  final TextEditingController _saranController = TextEditingController();
  bool _loading = false;

  Map<String, dynamic> _getFeedbackStatus(double rating) {
    if (rating == 0) {
      return {
        "label": "Ketuk bintang untuk menilai",
        "color": Colors.grey,
        "icon": Icons.sentiment_neutral
      };
    }
    if (rating <= 1) {
      return {
        "label": "Sangat Kecewa",
        "color": Colors.red,
        "icon": Icons.sentiment_very_dissatisfied
      };
    }
    if (rating <= 2) {
      return {
        "label": "Kurang Puas",
        "color": Colors.orange,
        "icon": Icons.sentiment_dissatisfied
      };
    }
    if (rating <= 3) {
      return {
        "label": "Cukup Baik",
        "color": Colors.amber,
        "icon": Icons.sentiment_neutral
      };
    }
    if (rating <= 4) {
      return {
        "label": "Sangat Puas",
        "color": Colors.lightGreen,
        "icon": Icons.sentiment_satisfied
      };
    }
    return {
      "label": "Luar Biasa!",
      "color": Colors.green,
      "icon": Icons.sentiment_very_satisfied
    };
  }

  Future<void> _submitSurvey() async {
    if (_rating == 0) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Mohon berikan rating terlebih dahulu"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade800,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final survey = SurveyData(
      rating: _rating,
      saran: _saranController.text.trim(),
      date: DateTime.now(),
    );

    try {
      await Supabase.instance.client
          .from('survey')
          .insert([survey.toJson()]);

      globalSurveyRepo.add(survey);

      _showSuccessDialog();
    } catch (e) {
      debugPrint("Error submit survey: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Gagal mengirim survey, coba lagi."),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Success",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.green, size: 80),
                  const SizedBox(height: 20),
                  const Text("Terima Kasih!",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    "Masukan Anda membantu kami meningkatkan kualitas layanan BPS Kudus.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Kembali ke Beranda",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _saranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = _getFeedbackStatus(_rating);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("Survey Kepuasan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Card rating
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(status['icon'],
                            key: ValueKey(_rating),
                            size: 90,
                            color: status['color']),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Bagaimana kualitas layanan kami?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                            color: status['color'],
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        child: Text(status['label']),
                      ),
                      const SizedBox(height: 25),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            double starValue = index + 1.0;
                            bool isSelected = _rating >= starValue;
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() => _rating = starValue);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: AnimatedScale(
                                  scale: isSelected ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    isSelected
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.grey.shade300,
                                    size: 50,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Input saran
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: TextField(
                    controller: _saranController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Ceritakan pengalaman Anda...",
                      labelText: "Saran & Masukan (Opsional)",
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Tombol kirim
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade700, Colors.orange.shade900],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submitSurvey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF39C12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Kirim Penilaian",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 10),
                        Icon(Icons.send_rounded, size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black38,
              child: const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}
