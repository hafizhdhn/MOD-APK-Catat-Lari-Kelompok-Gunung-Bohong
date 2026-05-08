// File: auth_provider.dart
// Provider untuk autentikasi — menyimpan daftar akun terdaftar dan user yang sedang login
// Akun disimpan ke SQLite via DatabaseHelper agar persist setelah app dimatikan

import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
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
///
/// Flow data:
/// 1. [initialize()] dipanggil di main() sebelum runApp — load semua akun dari DB
/// 2. Akun demo di-seed ke DB jika belum ada
/// 3. [login()] membaca dari memori (sudah di-load saat init)
/// 4. [register()] menyimpan ke DB dan memori sekaligus
/// 5. [logout()] hanya hapus currentUser dari memori
class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  // Daftar semua akun yang sudah terdaftar (di-load dari DB saat initialize)
  final List<AkunTerdaftar> _daftarAkun = [];

  // User yang sedang aktif login — null jika belum login
  UserModel? _currentUser;

  // ===== GETTERS =====

  /// User yang sedang login. Null jika belum login.
  UserModel? get currentUser => _currentUser;

  /// true jika ada user yang sedang login
  bool get sudahLogin => _currentUser != null;

  // ===== INISIALISASI =====

  /// Memuat semua akun dari database SQLite ke memori.
  ///
  /// Dipanggil sekali di main() sebelum runApp.
  /// Jika DB kosong (pertama kali install), seed akun demo terlebih dahulu.
  Future<void> initialize() async {
    final rows = await _db.getAllUsers();

    if (rows.isEmpty) {
      // Pertama kali: seed akun demo ke DB
      await _db.insertUser({
        DatabaseHelper.colUserId: 'demo_usr_001',
        DatabaseHelper.colUserNama: 'Ahmad Pelari',
        DatabaseHelper.colUserEmail: 'demo@catatlari.com',
        DatabaseHelper.colUserPassword: 'demo123',
      });
      // Muat ulang setelah seed
      final setelahSeed = await _db.getAllUsers();
      _muatAkunDariRows(setelahSeed);
    } else {
      _muatAkunDariRows(rows);
    }
  }

  /// Konversi baris database menjadi objek [AkunTerdaftar] dan simpan ke memori.
  void _muatAkunDariRows(List<Map<String, dynamic>> rows) {
    _daftarAkun.clear();
    for (final row in rows) {
      _daftarAkun.add(
        AkunTerdaftar(
          user: UserModel(
            id: row[DatabaseHelper.colUserId] as String,
            nama: row[DatabaseHelper.colUserNama] as String,
            email: row[DatabaseHelper.colUserEmail] as String,
          ),
          password: row[DatabaseHelper.colUserPassword] as String,
        ),
      );
    }
  }

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
  ///
  /// Menyimpan ke database SQLite secara sinkron (fire-and-forget),
  /// kemudian langsung update memori agar UI tidak perlu menunggu DB.
  /// Mengembalikan null jika berhasil, atau pesan error jika gagal.
  String? register(String nama, String email, String password) {
    final emailBersih = email.trim().toLowerCase();

    // Cek apakah email sudah terdaftar sebelumnya (dari memori)
    final sudahAda = _daftarAkun.any(
      (a) => a.user.email.toLowerCase() == emailBersih,
    );

    if (sudahAda) {
      return 'Email ini sudah digunakan. Silakan gunakan email lain atau masuk.';
    }

    // Buat akun baru dengan ID unik berbasis timestamp
    final id = 'usr_${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(id: id, nama: nama.trim(), email: email.trim());

    // Simpan ke DB (async fire-and-forget — tidak perlu await di sini)
    _db.insertUser({
      DatabaseHelper.colUserId: id,
      DatabaseHelper.colUserNama: nama.trim(),
      DatabaseHelper.colUserEmail: email.trim(),
      DatabaseHelper.colUserPassword: password,
    });

    // Update memori langsung agar UI responsif
    _daftarAkun.add(AkunTerdaftar(user: user, password: password));
    notifyListeners();
    return null; // null = sukses
  }

  /// Logout — hapus user aktif dari memori dan update flag GoRouter.
  /// Data aktivitas user tetap tersimpan di DB (isolasi per-userId).
  void logout() {
    _currentUser = null;
    AuthState.keluar();
    notifyListeners();
  }
}
