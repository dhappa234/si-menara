import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io'; // Untuk mendeteksi Platform otomatis

class AnalyticsService {
  static Future<void> recordAppEntry() async {
    final supabase = Supabase.instance.client;
    final prefs = await SharedPreferences.getInstance();

    // 1. Cek status install
    bool isFirstRun = prefs.getBool('is_first_run') ?? true;
    String eventName = isFirstRun ? 'app_install' : 'app_open';

    try {
      // 2. Kirim data ke Supabase
      await supabase.from('app_analytics').insert({
        'event_name': eventName,
        'platform': Platform.isAndroid ? 'Android' : 'iOS',
        'device_id': 'user_device', // Nanti bisa ditingkatkan pakai device_info_plus
      });

      // 3. Jika berhasil dan ini adalah install pertama, simpan tandanya
      if (isFirstRun) {
        await prefs.setBool('is_first_run', false);
      }

      print("Analytics: Berhasil mencatat $eventName");
    } catch (e) {
      print("Analytics Error: $e");
    }
  }
}