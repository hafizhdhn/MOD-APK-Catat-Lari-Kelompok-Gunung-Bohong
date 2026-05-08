// File: main_shell.dart
// Widget kerangka (shell) yang membungkus semua halaman bertab
// Menampilkan Bottom Navigation Bar yang persisten saat berpindah tab

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_constants.dart';
import '../utils/app_routes.dart';

/// MainShell adalah widget kerangka yang digunakan oleh ShellRoute di GoRouter.
/// Ia merender Bottom Navigation Bar Material 3 dan menampilkan konten tab
/// yang aktif melalui parameter [child].
class MainShell extends StatelessWidget {
  // Widget konten halaman tab yang sedang aktif (diteruskan oleh ShellRoute)
  final Widget child;

  // Path lokasi saat ini, digunakan untuk menentukan tab mana yang dipilih
  final String lokasiSaatIni;

  const MainShell({
    super.key,
    required this.child,
    required this.lokasiSaatIni,
  });

  /// Menghitung indeks tab yang aktif berdasarkan lokasi URL saat ini.
  /// Indeks 0 = Home, Indeks 1 = Profil
  int get _indeksAktif {
    if (lokasiSaatIni.startsWith(AppRoutes.profile)) return 1;
    // Default ke tab Home (indeks 0) untuk rute lainnya
    return 0;
  }

  /// Menangani tap pada item Bottom Navigation Bar.
  /// Menggunakan context.go() agar navigasi tidak menumpuk history.
  void _onTabDipilih(BuildContext context, int indeks) {
    switch (indeks) {
      case 0:
        // Navigasi ke halaman Home
        context.go(AppRoutes.home);
      case 1:
        // Navigasi ke halaman Profil
        context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Konten halaman tab yang aktif dirender di sini oleh ShellRoute
      body: child,

      // ===== BOTTOM NAVIGATION BAR MATERIAL 3 =====
      // NavigationBar adalah versi Material 3 dari BottomNavigationBar
      bottomNavigationBar: NavigationBar(
        // Indeks tab yang sedang aktif
        selectedIndex: _indeksAktif,

        // Callback saat pengguna mengetuk tab
        onDestinationSelected: (indeks) => _onTabDipilih(context, indeks),

        // Warna latar Navigation Bar mengikuti tema
        backgroundColor: colorScheme.surfaceContainer,

        // Tingkat elevasi bayangan
        elevation: 3,

        // Animasi perubahan indikator saat berpindah tab
        animationDuration: const Duration(milliseconds: 300),

        // Daftar tab yang ditampilkan di Navigation Bar
        destinations: const [
          // Tab 0: Beranda
          NavigationDestination(
            // Ikon tidak aktif (outline)
            icon: Icon(Icons.home_outlined),
            // Ikon aktif (filled) - ditampilkan saat tab ini dipilih
            selectedIcon: Icon(Icons.home_rounded),
            label: AppStrings.tabBeranda,
          ),

          // Tab 1: Profil
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: AppStrings.tabProfil,
          ),
        ],
      ),
    );
  }
}
