// File: widget_test.dart
// Pengujian dasar untuk memastikan aplikasi Catat Lari dapat dibangun tanpa error
// Jalankan dengan perintah: flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  // Smoke test: pastikan widget root aplikasi bisa di-render tanpa crash
  testWidgets('Aplikasi Catat Lari bisa dibuka tanpa error', (tester) async {
    // Bangun widget root dan render satu frame awal
    await tester.pumpWidget(const CatatLariApp());

    // Pastikan MaterialApp.router berhasil diinisialisasi
    expect(find.byType(CatatLariApp), findsOneWidget);
  });
}
