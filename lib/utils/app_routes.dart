// File: app_routes.dart
// Mendefinisikan semua nama rute (route name) navigasi aplikasi
// Menggunakan konstanta string agar tidak typo saat navigasi

/// Kelas AppRoutes menyimpan semua konstanta nama rute navigasi.
/// Digunakan bersama MaterialApp.routes dan Navigator.pushNamed().
class AppRoutes {
  // Konstruktor private agar kelas tidak bisa diinstansiasi
  AppRoutes._();

  // Rute awal saat aplikasi pertama kali dibuka (splash/login)
  static const String login = '/login';

  // Rute halaman pendaftaran akun baru
  static const String register = '/register';

  // Rute halaman utama setelah login berhasil
  static const String home = '/home';

  // Rute halaman profil pengguna
  static const String profile = '/profile';
}
