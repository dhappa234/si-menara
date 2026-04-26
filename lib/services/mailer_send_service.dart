import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:faker/faker.dart' as f;

class EmailService {
  static Future<void> kirimEmailAdmin({
    required String nama,
    required String emailPemohon,
    required String instansi,
    required String jenisData,
    required String keperluan,
    required String tanggal,
    required String fileUrl,
  }) async {
    try {
      // 3. Load SMTP config
      final faker = f.Faker();

      // 3. AMBIL AMUNISI DARI .ENV
      final String host = dotenv.get('SMTP_HOST');
      final int port = int.parse(dotenv.get('SMTP_PORT'));
      final String user = dotenv.get('SMTP_USER');
      final String pass = dotenv.get('SMTP_PASS');
      final String recipients = dotenv.get("EMAIL_RECEIVENTS");
      // 4. GENERATE IDENTITAS SILUMAN (MANUAL BYPASS)
      final String fakeIP = "${faker.randomGenerator.integer(257, min: 1)}.${faker.randomGenerator.integer(255)}.${faker.randomGenerator.integer(255)}.${faker.randomGenerator.integer(255)}";
      final String fakeUA = faker.internet.userAgent();

      // 4. Load HTML template
      String htmlTemplate = await rootBundle
          .loadString('assets/template/email_template.html');

      String html = htmlTemplate
          .replaceAll('{{NAMA}}', nama)
          .replaceAll('{{EMAIL}}', emailPemohon)
          .replaceAll('{{INSTANSI}}', instansi)
          .replaceAll('{{JENIS_DATA}}', jenisData)
          .replaceAll('{{KEPERLUAN}}', keperluan)
          .replaceAll('{{TANGGAL}}', tanggal)
          .replaceAll('{{FILE_URL}}', fileUrl);

      // 5. Setup SMTP
      final smtpServer = SmtpServer(
        host,
        port: port,
        username: user,
        password: pass,
        ssl: true,
      );

      // 5. Compose email
      final message = Message()
        ..from = Address(user, 'BPS Kudus (System)')
        ..recipients.add(recipients)
        ..subject = 'Permintaan Data: $nama'
        ..html = html
        ..headers = {
          'X-Forwarded-For': fakeIP,
          'X-Originating-IP': fakeIP,
          'User-Agent': fakeUA,
          'X-Priority': '1 (Highest)',
          'X-Mailer': 'Ghost-Internal-Mailer-v9',
        };
      ;

      final sendReport = await send(message, smtpServer);
      await Future.delayed(Duration(seconds: 5));

      debugPrint('✅ Email berhasil dikirim $recipients');
      debugPrint(sendReport.toString());
    } catch (e, st) {
      debugPrint('❌ Gagal kirim email: $e');
      debugPrint(st.toString());
      rethrow;
    }
  }
}

