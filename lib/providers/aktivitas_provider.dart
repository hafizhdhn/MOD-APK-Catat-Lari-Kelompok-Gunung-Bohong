// File: aktivitas_provider.dart
// Provider untuk mengelola state daftar aktivitas lari per-pengguna
// Semua operasi CRUD dan statistik diisolasi berdasarkan userId

import 'package:flutter/foundation.dart';
import '../models/aktivitas_lari.dart';

/// AktivitasProvider mengelola semua operasi CRUD untuk aktivitas lari.
/// Data diisolasi per-user — setiap user hanya bisa melihat dan mengelola
/// aktivitas miliknya sendiri (berdasarkan userId).
class AktivitasProvider extends ChangeNotifier {
  // Daftar semua aktivitas dari semua user — difilter saat dibaca
  final List<AktivitasLari> _aktivitas = [];

  /// Konstruktor — inisialisasi dengan data demo untuk akun Ahmad Pelari
  AktivitasProvider() {
    _seedData();
  }

  /// Mengisi 5 data demo khusus untuk akun demo (id: 'demo_usr_001').
  /// User baru tidak mendapat data awal — daftar aktivitasnya kosong.
  void _seedData() {
    _aktivitas.addAll([
      AktivitasLari(
        id: 'seed_1',
        userId: 'demo_usr_001',
        jarakKm: 5.2,
        waktuMenit: 32,
        tanggal: DateTime(2026, 5, 6),
        catatan: 'Lari pagi yang menyegarkan',
      ),
      AktivitasLari(
        id: 'seed_2',
        userId: 'demo_usr_001',
        jarakKm: 10.0,
        waktuMenit: 65,
        tanggal: DateTime(2026, 5, 4),
        catatan: 'Lari kelompok — seru!',
      ),
      AktivitasLari(
        id: 'seed_3',
        userId: 'demo_usr_001',
        jarakKm: 3.8,
        waktuMenit: 22,
        tanggal: DateTime(2026, 5, 2),
        catatan: '',
      ),
      AktivitasLari(
        id: 'seed_4',
        userId: 'demo_usr_001',
        jarakKm: 7.1,
        waktuMenit: 44,
        tanggal: DateTime(2026, 4, 30),
        catatan: 'Latihan ringan sebelum lomba',
      ),
      AktivitasLari(
        id: 'seed_5',
        userId: 'demo_usr_001',
        jarakKm: 8.5,
        waktuMenit: 52,
        tanggal: DateTime(2026, 4, 27),
        catatan: 'Sesi akhir pekan bersama tim',
      ),
    ]);
  }

  // ===== GETTERS PER-USER =====

  /// Mengembalikan daftar aktivitas milik user tertentu, diurutkan terbaru dulu.
  List<AktivitasLari> getAktivitasByUser(String userId) {
    final filtered = _aktivitas.where((a) => a.userId == userId).toList();
    filtered.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return filtered;
  }

  /// Total jarak (km) dari semua aktivitas milik user tertentu
  double getTotalJarakKmByUser(String userId) {
    return _aktivitas
        .where((a) => a.userId == userId)
        .fold(0.0, (jumlah, a) => jumlah + a.jarakKm);
  }

  /// Total jarak diformat ke satu desimal, misal "26.1 km"
  String getTotalJarakFormattedByUser(String userId) =>
      '${getTotalJarakKmByUser(userId).toStringAsFixed(1)} km';

  /// Jumlah total sesi lari milik user tertentu
  int getTotalSesiByUser(String userId) =>
      _aktivitas.where((a) => a.userId == userId).length;

  /// Total durasi semua aktivitas milik user tertentu (dalam menit)
  int getTotalWaktuMenitByUser(String userId) {
    return _aktivitas
        .where((a) => a.userId == userId)
        .fold(0, (jumlah, a) => jumlah + a.waktuMenit);
  }

  /// Total estimasi kalori terbakar milik user tertentu
  int getTotalKaloriByUser(String userId) {
    return _aktivitas
        .where((a) => a.userId == userId)
        .fold(0, (jumlah, a) => jumlah + a.kaloriEstimasi);
  }

  /// Rata-rata pace dari semua aktivitas milik user tertentu, format "6:14 /km"
  String getAvgPaceFormattedByUser(String userId) {
    final totalJarak = getTotalJarakKmByUser(userId);
    if (totalJarak <= 0) return '--:--';
    final totalWaktu = getTotalWaktuMenitByUser(userId);
    final avgMenPerKm = totalWaktu / totalJarak;
    final totalDetik = (avgMenPerKm * 60).round();
    final menit = totalDetik ~/ 60;
    final detik = totalDetik % 60;
    return '$menit:${detik.toString().padLeft(2, '0')}';
  }

  // ===== METODE CRUD =====

  /// CREATE — Menambahkan aktivitas baru ke daftar.
  /// notifyListeners() memberitahu semua Consumer untuk rebuild.
  void tambah(AktivitasLari aktivitas) {
    _aktivitas.add(aktivitas);
    notifyListeners();
  }

  /// UPDATE — Memperbarui aktivitas yang sudah ada berdasarkan ID.
  /// Mencari aktivitas dengan ID yang sama, lalu menggantinya.
  void perbarui(AktivitasLari aktivitasBaru) {
    final indeks = _aktivitas.indexWhere((a) => a.id == aktivitasBaru.id);
    if (indeks != -1) {
      _aktivitas[indeks] = aktivitasBaru;
      notifyListeners();
    }
  }

  /// DELETE — Menghapus aktivitas berdasarkan ID, hanya jika userId cocok.
  /// Pemeriksaan ganda (id + userId) mencegah user A menghapus data user B.
  void hapus(String id, String userId) {
    _aktivitas.removeWhere((a) => a.id == id && a.userId == userId);
    notifyListeners();
  }
}
