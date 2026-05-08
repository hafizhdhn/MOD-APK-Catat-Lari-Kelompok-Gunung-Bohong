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
void main() {
  // Pastikan binding Flutter sudah siap sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();

  // MultiProvider membungkus seluruh aplikasi agar semua screen
  // bisa mengakses provider yang terdaftar via context.read/watch
  runApp(
    MultiProvider(
      providers: [
        // Provider autentikasi: daftar akun, user aktif, login/register/logout
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Provider daftar aktivitas lari + operasi CRUD
        ChangeNotifierProvider(create: (_) => AktivitasProvider()),
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
