import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
      debugPrint("ERROR: $e");

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
                        // ================= ICON =================
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: Colors.orange.shade50,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  size: 60,
                                  color: Colors.orange,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Klik untuk buka",
                                  style: TextStyle(
                                    color: Colors.orange,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        // ================= TITLE =================
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
