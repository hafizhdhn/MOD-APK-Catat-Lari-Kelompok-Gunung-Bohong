// File: main.dart
// Titik masuk utama aplikasi Catat Lari
// Mengatur tema dan meneruskan konfigurasi router ke MaterialApp

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import konfigurasi tema Material 3 kustom
import 'utils/app_theme.dart';

// Import konfigurasi GoRouter yang berisi semua rute dan redirect logic
import 'utils/app_router.dart';

// Import semua Provider untuk state management
import 'providers/auth_provider.dart';
import 'providers/aktivitas_provider.dart';

/// Fungsi main adalah titik masuk pertama yang dijalankan saat aplikasi dibuka.
///
/// Provider dibuat manual di sini agar [initialize()] bisa di-await sebelum
/// [runApp] dipanggil — memastikan data dari DB sudah tersedia saat UI pertama kali dirender.
void main() async {
  // Pastikan binding Flutter sudah siap sebelum mengakses platform channel (DB)
  WidgetsFlutterBinding.ensureInitialized();

  // Buat provider di luar runApp agar bisa di-await
  final authProvider = AuthProvider();
  final aktivitasProvider = AktivitasProvider();

  // Muat data dari SQLite sebelum UI dirender
  // Urutan penting: auth dulu karena aktivitas butuh user_id dari akun yang di-seed
  await authProvider.initialize();
  await aktivitasProvider.initialize();

  // MultiProvider membungkus seluruh aplikasi agar semua screen
  // bisa mengakses provider yang terdaftar via context.read/watch
  runApp(
    MultiProvider(
      providers: [
        // Gunakan .value karena instance sudah dibuat dan di-init di atas
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: aktivitasProvider),
      ],
      child: const CatatLariApp(),
    ),
  );
}

/// CatatLariApp adalah widget root aplikasi.
/// Menggunakan MaterialApp.router agar GoRouter bisa mengelola navigasi penuh.
class CatatLariApp extends StatelessWidget {
  const CatatLariApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router menggantikan MaterialApp biasa
    // agar GoRouter bisa mengontrol seluruh sistem navigasi
    return MaterialApp.router(
      // Judul aplikasi (tampil di task switcher OS)
      title: 'Catat Lari',

      // Sembunyikan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // Terapkan tema Material 3 kustom dari AppTheme
      theme: AppTheme.lightTheme,

      // Teruskan konfigurasi GoRouter sebagai sumber kebenaran navigasi
      // GoRouter menangani: rute, redirect, deep link, dll.
      routerConfig: AppRouter.router,
    );
  }
}
