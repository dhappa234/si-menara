import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simenara/services/mailer_send_service.dart';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Load .env untuk environment test
    await dotenv.load(fileName: ".env");

    // Mock asset untuk HTML template (biar rootBundle.loadString nggak error)
    const String fakeHtmlTemplate = '''
      <html>
        <body>
          <h1>{{NAMA}}</h1>
          <p>{{EMAIL}}</p>
          <p>{{INSTANSI}}</p>
          <p>{{JENIS_DATA}}</p>
          <p>{{KEPERLUAN}}</p>
          <p>{{TANGGAL}}</p>
          <p>{{FILE_URL}}</p>
        </body>
      </html>
    ''';

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final String key = String.fromCharCodes(message!.buffer.asUint8List());
      if (key == 'assets/template/email_template.html') {
        return ByteData.view(
          Uint8List.fromList(fakeHtmlTemplate.codeUnits).buffer,
        );
      }
      return null;
    });
  });

  test('kirimEmailAdmin() tidak throw error', () async {
    // NOTE: ini test REAL SMTP (beneran kirim email)
    await EmailService.kirimEmailAdmin(
      nama: 'Test User',
      emailPemohon: 'ibnuaqil0912@gmail.com',
      instansi: 'Instansi Test',
      jenisData: 'Data Dummy',
      keperluan: 'Pengujian unit test',
      tanggal: DateTime.now().toIso8601String(),
      fileUrl: 'https://example.com/file.pdf',
    );

    expect(true, isTrue); // kalau sampai sini berarti sukses
  });
}

