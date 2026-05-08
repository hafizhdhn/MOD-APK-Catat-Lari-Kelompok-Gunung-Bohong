// File: app_router.dart
// Konfigurasi utama sistem navigasi GoRouter untuk aplikasi Catat Lari
// Menentukan semua rute, struktur navigasi, dan logika redirect (guard)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/register/register_screen.dart';
import '../widgets/main_shell.dart';
import 'app_routes.dart';
import 'auth_state.dart';

/// Kelas AppRouter menyediakan instance GoRouter yang dipakai di seluruh aplikasi.
/// Menggunakan pola singleton agar router tidak dibuat ulang setiap build.
class AppRouter {
  AppRouter._();

  /// Instance GoRouter tunggal yang digunakan oleh MaterialApp.router
  static final GoRouter router = GoRouter(
    // Lokasi awal saat aplikasi pertama dibuka
    initialLocation: AppRoutes.login,

    // ===== LOGIKA REDIRECT (ROUTE GUARD) =====
    // Dipanggil setiap kali ada navigasi untuk mengecek apakah pengguna
    // boleh mengakses halaman tersebut
    redirect: (BuildContext context, GoRouterState state) {
      // Ambil path halaman yang ingin dituju
      final lokasiTujuan = state.matchedLocation;

      // Cek apakah pengguna sudah login
      final sudahLogin = AuthState.isLoggedIn;

      // Daftar halaman yang boleh diakses tanpa login
      final halamanPublik = [AppRoutes.login, AppRoutes.register];
      final menujuHalamanPublik = halamanPublik.contains(lokasiTujuan);

      // Kalau belum login dan menuju halaman yang butuh login → paksa ke login
      if (!sudahLogin && !menujuHalamanPublik) {
        return AppRoutes.login;
      }

      // Kalau sudah login tapi masih di halaman login → langsung ke home
      if (sudahLogin && lokasiTujuan == AppRoutes.login) {
        return AppRoutes.home;
      }

      // Null berarti tidak ada redirect - lanjutkan ke halaman yang dituju
      return null;
    },

    // ===== DAFTAR SEMUA RUTE APLIKASI =====
    routes: [
      // --- Rute Login ---
      // Halaman masuk untuk pengguna yang belum/sudah punya akun
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        // pageBuilder digunakan untuk mengontrol animasi transisi halaman
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginScreen(),
        ),
      ),

      // --- Rute Register ---
      // Halaman pendaftaran akun baru dengan animasi slide dari bawah
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          // Animasi slide dari bawah ke atas saat membuka halaman register
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
                  CurveTween(curve: Curves.easeInOut),
                ),
              ),
              child: child,
            );
          },
        ),
      ),

      // --- ShellRoute untuk halaman dengan Bottom Navigation Bar ---
      // ShellRoute membungkus beberapa halaman dalam satu "shell" (kerangka)
      // sehingga Bottom Navigation Bar tetap terlihat saat berpindah tab
      ShellRoute(
        // Builder menerima `child` yang merupakan screen tab yang aktif
        builder: (context, state, child) {
          return MainShell(
            // Teruskan lokasi saat ini ke shell agar tahu tab mana yang aktif
            lokasiSaatIni: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          // Tab Home - halaman utama dengan statistik lari
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),

          // Tab Profile - halaman profil dan pengaturan pengguna
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}
