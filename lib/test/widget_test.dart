import 'package:simenara/services/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simenara/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Generate mocks
@GenerateMocks([SupabaseClient])
void main() {
  // Initialize test bindings
  TestWidgetsFlutterBinding.ensureInitialized();

  // Test 1: Verify app initialization
  testWidgets('App starts and shows AuthWrapper', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MaterialApp(home: AuthWrapper()));

    // Verify AuthWrapper is rendered
    expect(find.byType(AuthWrapper), findsOneWidget);
  });

  // Test 2: Verify EditProfilBpsPage UI elements
  testWidgets('EditProfilBpsPage displays all menu items', (
      WidgetTester tester,
      ) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EditProfilBpsPage())),
    );
    expect(find.text('Profil BPS'), findsOneWidget);
    final menuItems = [
      'Informasi Umum BPS',
      'Visi dan Misi BPS',
      'Struktur Organisasi BPS',
      'Tugas, Fungsi, dan Kewenangan BPS',
      'Pengolahan Data BPS',
      'Sejarah BPS',
      'Arti Logo BPS',
      'Alamat dan Kontak BPS',
      'Profil Pejabat BPS',
    ];

    for (var item in menuItems) {
      expect(find.text(item), findsOneWidget);
    }
  });
  testWidgets('Tapping menu item shows correct page', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const MaterialApp(home: EditProfilBpsPage()));
    await tester.tap(find.text('Informasi Umum BPS').first);
    await tester.pumpAndSettle();

    expect(find.byType(InformasiUmum), findsOneWidget);
  });
}

class InformasiUmum {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
