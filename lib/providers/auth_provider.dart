// File: auth_provider.dart
// Provider untuk autentikasi — menyimpan daftar akun terdaftar dan user yang sedang login
// Menggantikan UserProvider agar login/register benar-benar tervalidasi

import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../utils/auth_state.dart';

/// Data internal satu akun yang terdaftar.
/// Menyimpan objek user publik dan password (plaintext — hanya untuk demo).
class AkunTerdaftar {
  final UserModel user;
  final String password;

  const AkunTerdaftar({required this.user, required this.password});
}

/// AuthProvider mengelola autentikasi: daftar akun, login, register, dan logout.
/// Saat login berhasil, [currentUser] diisi dan [AuthState.masuk()] dipanggil
/// agar GoRouter mengizinkan akses ke halaman dalam aplikasi.
class AuthProvider extends ChangeNotifier {
  // Daftar semua akun yang sudah terdaftar (email unik sebagai identifier)
  final List<AkunTerdaftar> _daftarAkun = [];

  // User yang sedang aktif login — null jika belum login
  UserModel? _currentUser;

  /// Konstruktor — inisialisasi dengan satu akun demo yang sudah terisi data
  AuthProvider() {
    _seedAkunDemo();
  }

  /// Menyiapkan akun demo bawaan untuk keperluan presentasi dan testing.
  /// Akun ini sudah punya 5 aktivitas lari di AktivitasProvider.
  void _seedAkunDemo() {
    _daftarAkun.add(
      const AkunTerdaftar(
        user: UserModel(
          id: 'demo_usr_001',
          nama: 'Ahmad Pelari',
          email: 'demo@catatlari.com',
        ),
        password: 'demo123',
      ),
    );
  }

  // ===== GETTERS =====

  /// User yang sedang login. Null jika belum login.
  UserModel? get currentUser => _currentUser;

  /// true jika ada user yang sedang login
  bool get sudahLogin => _currentUser != null;

  // ===== METODE AUTENTIKASI =====

  /// Login dengan email dan password.
  /// Mengembalikan null jika berhasil, atau pesan error jika gagal.
  String? login(String email, String password) {
    final emailBersih = email.trim().toLowerCase();

    // Cari akun berdasarkan email (case-insensitive)
    AkunTerdaftar? akun;
    for (final a in _daftarAkun) {
      if (a.user.email.toLowerCase() == emailBersih) {
        akun = a;
        break;
      }
    }

    if (akun == null) {
      return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
    }

    if (akun.password != password) {
      return 'Password salah. Periksa kembali password Anda.';
    }

    // Login berhasil — simpan user aktif dan update flag GoRouter
    _currentUser = akun.user;
    AuthState.masuk();
    notifyListeners();
    return null; // null = sukses
  }

  /// Mendaftarkan akun baru dengan nama, email, dan password.
  /// Mengembalikan null jika berhasil, atau pesan error jika gagal.
  String? register(String nama, String email, String password) {
    final emailBersih = email.trim().toLowerCase();

    // Cek apakah email sudah terdaftar sebelumnya
    final sudahAda = _daftarAkun.any(
      (a) => a.user.email.toLowerCase() == emailBersih,
    );

    if (sudahAda) {
      return 'Email ini sudah digunakan. Silakan gunakan email lain atau masuk.';
    }

    // Buat akun baru dengan ID unik berbasis timestamp
    _daftarAkun.add(
      AkunTerdaftar(
        user: UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          nama: nama.trim(),
          email: email.trim(),
        ),
        password: password,
      ),
    );
    notifyListeners();
    return null; // null = sukses
  }

  /// Logout — hapus user aktif dan update flag GoRouter.
  /// Data aktivitas user tetap tersimpan di AktivitasProvider (isolasi per-userId).
  void logout() {
    _currentUser = null;
    AuthState.keluar();
    notifyListeners();
  }
}
