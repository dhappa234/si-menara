import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/infografis_model.dart';

class BpsService {
  // ================= KONFIG API =================
  static const String _apiKey = '4357b7707bff6d60ba68cddaa46f32e1';
  static const String _domain = '3319';
  static const String _baseUrl = 'https://webapi.bps.go.id/v1/api';
  static const String _listUrl = 'https://webapi.bps.go.id/v1/api/list';

  // AI Chat
  static const String _groqApiKey =
      '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';
  static const String _groqUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  // ================= KATEGORI =================
  static List<int> getSosialVarIds() =>
      [130, 43, 145, 30, 95, 121, 120, 227, 33, 225];
  static List<int> getEkonomiVarIds() => [118, 207, 148, 1, 188];
  static List<int> getPertanianVarIds() => [45];

  // ================= CEK KONEKSI =================
  static Future<bool> checkConnection() async {
    try {
      final url = Uri.parse('$_listUrl?model=var&domain=$_domain&key=$_apiKey');
      final res = await http.get(url).timeout(const Duration(seconds: 10));
      return res.statusCode == 200 && jsonDecode(res.body)['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  // ================= VARIABEL =================
  static Future<List<Map<String, dynamic>>> getDataByVar() async {
    try {
      final url = Uri.parse('$_listUrl?model=var&domain=$_domain&key=$_apiKey');
      final res = await http.get(url);
      if (res.statusCode != 200) return [];
      final jsonData = jsonDecode(res.body);
      if (jsonData['data'] == null || (jsonData['data'] as List).length < 2) {
        return [];
      }
      final List listData = jsonData['data'][1];
      return List<Map<String, dynamic>>.from(listData);
    } catch (e) {
      debugPrint("getDataByVar ERROR: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> getVariableMetadata(int varId) async {
    try {
      final url = Uri.parse('$_listUrl?model=var&domain=$_domain&key=$_apiKey');
      final res = await http.get(url);
      final jsonData = jsonDecode(res.body);
      String finalLabel = "Variabel $varId";

      if (jsonData['status'] == 'OK' && jsonData['data'] != null) {
        final list = jsonData['data'][1] ?? [];
        var target = list.firstWhere(
          (v) =>
              v['var_id'].toString() == varId.toString() ||
              v['val'].toString() == varId.toString(),
          orElse: () => null,
        );
        if (target != null) {
          finalLabel = target['label'] ?? target['title'] ?? finalLabel;
        }
      }

      // Ambil tahun terbaru
      final urlTh = Uri.parse(
          '$_listUrl?model=th&domain=$_domain&var=$varId&key=$_apiKey');
      final resTh = await http.get(urlTh);
      final jsonTh = jsonDecode(resTh.body);
      String latestYear = "-";
      if (jsonTh['status'] == 'OK' &&
          jsonTh['data'] != null &&
          jsonTh['data'].length > 1) {
        final years = jsonTh['data'][1];
        if (years.isNotEmpty) latestYear = years.last['th'].toString();
      }

      return {'title': finalLabel, 'year': latestYear};
    } catch (e) {
      debugPrint("Metadata ERROR: $e");
      return {'title': "Variabel $varId", 'year': "-"};
    }
  }

  // ================= TAHUN =================
  static Future<List<int>> fetchAvailableYears(int varId) async {
    try {
      final url = Uri.parse(
          '$_listUrl?model=th&domain=$_domain&var=$varId&key=$_apiKey');
      final res = await http.get(url);
      final jsonData = jsonDecode(res.body);
      if (jsonData['status'] == 'OK' &&
          jsonData['data'] != null &&
          jsonData['data'].length > 1) {
        final list = jsonData['data'][1];
        return list
            .map<int>((e) => int.tryParse(e['th'].toString()) ?? 0)
            .where((e) => e != 0)
            .toList();
      }
    } catch (e) {
      debugPrint("Year ERROR: $e");
    }
    return [2025, 2024, 2023, 2022, 2021];
  }

  // ================= DATA STATISTIK =================
  static Future<Map<String, dynamic>> fetchStatData({
    required int varId,
    int? year,
  }) async {
    final int selectedYear = year ?? 2023;
    String thIdActual = (selectedYear - 1900).toString();

    try {
      final urlTh = Uri.parse(
          '$_listUrl?model=th&domain=$_domain&var=$varId&key=$_apiKey');
      final resTh = await http.get(urlTh).timeout(const Duration(seconds: 15));
      final jsonTh = jsonDecode(resTh.body);

      if (jsonTh is Map &&
          jsonTh['status'] == 'OK' &&
          jsonTh['data'] != null &&
          jsonTh['data'].length > 1) {
        final listTh = jsonTh['data'][1];
        final match = listTh.firstWhere(
          (e) => e['th'].toString() == selectedYear.toString(),
          orElse: () => null,
        );
        if (match != null) thIdActual = match['th_id'].toString();
      }

      final url = Uri.parse(
          '$_listUrl?model=data&domain=$_domain&var=$varId&th=$thIdActual&key=$_apiKey');
      final res = await http.get(url).timeout(const Duration(seconds: 20));
      final decoded = jsonDecode(res.body);

      if (decoded['status'] != 'OK') {
        return {
          'columns': [],
          'rows': [],
          'title': 'Data Tidak Ada',
          'unit': ''
        };
      }

      Map<String, dynamic> datacontent =
          Map<String, dynamic>.from(decoded['datacontent'] ?? {});
      final List varList = decoded['var'] ?? [];
      final title = varList.isNotEmpty ? varList[0]['label'] : 'Data Statistik';
      final unit = varList.isNotEmpty ? varList[0]['unit'] : '';
      final List vervar = decoded['vervar'] ?? [];
      final List turvar = decoded['turvar'] ?? [];
      final List turtahun = decoded['turtahun'] ?? [];

      List<Map<String, dynamic>> columns = [];
      for (var t in turvar) {
        for (var tt in turtahun) {
          columns.add({
            'id': t['val'].toString(),
            'ttId': tt['val'].toString(),
            'label': (t['label'] == '-' || t['label'] == 'Tidak ada')
                ? tt['label']
                : "${t['label']} (${tt['label']})",
          });
        }
      }

      List<Map<String, dynamic>> rows = [];
      for (var v in vervar) {
        String vId = v['val'].toString();
        Map<String, dynamic> row = {'label_wilayah': v['label']};
        for (var col in columns) {
          String key = "$vId$varId${col['id']}$thIdActual${col['ttId']}";
          row[col['label']] = datacontent[key]?.toString() ?? '-';
        }
        rows.add(row);
      }

      return {'title': title, 'unit': unit, 'columns': columns, 'rows': rows};
    } catch (e) {
      debugPrint("Stat ERROR: $e");
      return {'columns': [], 'rows': [], 'title': 'Error', 'unit': ''};
    }
  }

  // ================= AI CHAT =================
  static Future<String> getChatbotResponse({
    required String systemPrompt,
    required List<Map<String, dynamic>> messages,
  }) async {
    try {
      final url = Uri.parse(_groqUrl);
      final res = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_groqApiKey',
            },
            body: jsonEncode({
              "model": "llama-3.1-8b-instant",
              "messages": [
                {"role": "system", "content": systemPrompt},
                ...messages
              ],
              "temperature": 0.7,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception("AI Error ${res.statusCode}");
      }
    } on SocketException {
      throw Exception("Tidak ada internet");
    } on TimeoutException {
      throw Exception("Timeout");
    }
  }

  // ================= INFOGRAFIS =================
  static Future<List<InfografisModel>> getInfografis() async {
    List<InfografisModel> allData = [];

    int page = 1;
    int totalPage = 1;

    try {
      do {
        final url = Uri.parse(
            '$_baseUrl/list/model/infographic/domain/$_domain/page/$page/key/$_apiKey');
        final res = await http.get(url);

        if (res.statusCode != 200) break;

        final jsonData = jsonDecode(res.body);

        if (jsonData['data'] == null || (jsonData['data'] as List).length < 2) {
          break;
        }

        final info = jsonData['data'][0];

        totalPage = info['pages'] ?? 1;

        final List list = jsonData['data'][1];

        final parsed = list.map((e) => InfografisModel.fromJson(e)).toList();

        allData.addAll(parsed);

        page++;
      } while (page <= totalPage);

      return allData;
    } catch (e) {
      debugPrint("Infografis ERROR: $e");
      return [];
    }
  }
}
