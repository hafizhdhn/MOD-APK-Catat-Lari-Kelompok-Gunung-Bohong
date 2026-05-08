// File: user_provider.dart
// Provider untuk mengelola data pengguna yang sedang login
// Memastikan semua screen menampilkan data user yang sama dan sinkron

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// UserProvider menyimpan dan mendistribusikan data pengguna yang aktif login.
/// Semua screen yang consume provider ini akan otomatis rebuild saat user berubah.
class UserProvider extends ChangeNotifier {
  // Data pengguna saat ini — null berarti belum login
  UserModel? _user;

  /// Getter untuk mengakses data pengguna dari luar
  UserModel? get user => _user;

  /// Apakah ada pengguna yang sedang login
  bool get sudahLogin => _user != null;

  /// Menyimpan data pengguna setelah login berhasil.
  /// Dipanggil dari LoginScreen setelah proses autentikasi selesai.
  void setUser(UserModel user) {
    _user = user;
    // Beritahu semua Consumer untuk rebuild dengan data user baru
    notifyListeners();
  }

  /// Menghapus data pengguna saat logout.
  /// Dipanggil dari ProfileScreen saat pengguna memilih keluar.
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
