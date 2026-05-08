// File: aktivitas_provider.dart
// Provider untuk mengelola state daftar aktivitas lari per-pengguna
// Data disimpan ke SQLite via DatabaseHelper agar persist antar sesi

import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/aktivitas_lari.dart';

/// AktivitasProvider mengelola semua operasi CRUD untuk aktivitas lari.
///
/// Flow data:
/// 1. [initialize()] dipanggil di main() — load semua aktivitas dari DB
/// 2. Data demo di-seed ke DB hanya jika belum ada (pertama install)
/// 3. [tambah()], [perbarui()], [hapus()] update memori langsung + simpan ke DB
///
/// Pola write-through: UI diperbarui segera dari memori, DB diperbarui di belakang.
/// Data diisolasi per-user — setiap getter memfilter berdasarkan userId.
class AktivitasProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  // Daftar semua aktivitas dari semua user — difilter saat dibaca
  final List<AktivitasLari> _aktivitas = [];

  // ===== INISIALISASI =====

  /// Memuat semua aktivitas dari database SQLite ke memori.
  ///
  /// Dipanggil sekali di main() sebelum runApp.
  /// Jika DB kosong, seed 5 aktivitas demo untuk akun 'demo_usr_001'.
  Future<void> initialize() async {
    final rows = await _db.getAllActivities();

    if (rows.isEmpty) {
      // Pertama kali: seed data demo ke DB
      await _seedDataDemo();
      // Muat ulang setelah seed
      final setelahSeed = await _db.getAllActivities();
      _muatAktivitasDariRows(setelahSeed);
    } else {
      _muatAktivitasDariRows(rows);
    }
  }

  /// Konversi baris database menjadi objek [AktivitasLari] dan simpan ke memori.
  void _muatAktivitasDariRows(List<Map<String, dynamic>> rows) {
    _aktivitas.clear();
    for (final row in rows) {
      _aktivitas.add(
        AktivitasLari(
          id: row[DatabaseHelper.colActId] as String,
          userId: row[DatabaseHelper.colActUserId] as String,
          jarakKm: (row[DatabaseHelper.colActJarak] as num).toDouble(),
          waktuMenit: row[DatabaseHelper.colActWaktu] as int,
          tanggal: DateTime.parse(row[DatabaseHelper.colActTanggal] as String),
          catatan: row[DatabaseHelper.colActCatatan] as String? ?? '',
        ),
      );
    }
  }

  /// Menyisipkan 5 aktivitas demo ke DB untuk akun Ahmad Pelari.
  /// Dipanggil hanya sekali saat install pertama.
  Future<void> _seedDataDemo() async {
    final demoData = [
      {
        DatabaseHelper.colActId: 'seed_1',
        DatabaseHelper.colActUserId: 'demo_usr_001',
        DatabaseHelper.colActJarak: 5.2,
        DatabaseHelper.colActWaktu: 32,
        DatabaseHelper.colActTanggal: DateTime(2026, 5, 6).toIso8601String(),
        DatabaseHelper.colActCatatan: 'Lari pagi yang menyegarkan',
      },
      {
        DatabaseHelper.colActId: 'seed_2',
        DatabaseHelper.colActUserId: 'demo_usr_001',
        DatabaseHelper.colActJarak: 10.0,
        DatabaseHelper.colActWaktu: 65,
        DatabaseHelper.colActTanggal: DateTime(2026, 5, 4).toIso8601String(),
        DatabaseHelper.colActCatatan: 'Lari kelompok — seru!',
      },
      {
        DatabaseHelper.colActId: 'seed_3',
        DatabaseHelper.colActUserId: 'demo_usr_001',
        DatabaseHelper.colActJarak: 3.8,
        DatabaseHelper.colActWaktu: 22,
        DatabaseHelper.colActTanggal: DateTime(2026, 5, 2).toIso8601String(),
        DatabaseHelper.colActCatatan: '',
      },
      {
        DatabaseHelper.colActId: 'seed_4',
        DatabaseHelper.colActUserId: 'demo_usr_001',
        DatabaseHelper.colActJarak: 7.1,
        DatabaseHelper.colActWaktu: 44,
        DatabaseHelper.colActTanggal: DateTime(2026, 4, 30).toIso8601String(),
        DatabaseHelper.colActCatatan: 'Latihan ringan sebelum lomba',
      },
      {
        DatabaseHelper.colActId: 'seed_5',
        DatabaseHelper.colActUserId: 'demo_usr_001',
        DatabaseHelper.colActJarak: 8.5,
        DatabaseHelper.colActWaktu: 52,
        DatabaseHelper.colActTanggal: DateTime(2026, 4, 27).toIso8601String(),
        DatabaseHelper.colActCatatan: 'Sesi akhir pekan bersama tim',
      },
    ];

    for (final data in demoData) {
      await _db.insertActivity(data);
    }
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

  /// CREATE — Menambahkan aktivitas baru ke memori dan menyimpan ke DB.
  ///
  /// Memori diperbarui dulu agar UI langsung responsif (write-through).
  /// DB diperbarui secara async di belakang layar.
  void tambah(AktivitasLari aktivitas) {
    _aktivitas.add(aktivitas);
    notifyListeners();

    // Simpan ke DB secara async — tidak perlu await (fire-and-forget)
    _db.insertActivity(_aktivitasKeMap(aktivitas));
  }

  /// UPDATE — Memperbarui aktivitas di memori dan di DB berdasarkan ID.
  void perbarui(AktivitasLari aktivitasBaru) {
    final indeks = _aktivitas.indexWhere((a) => a.id == aktivitasBaru.id);
    if (indeks != -1) {
      _aktivitas[indeks] = aktivitasBaru;
      notifyListeners();

      // Perbarui di DB secara async
      _db.updateActivity(_aktivitasKeMap(aktivitasBaru));
    }
  }

  /// DELETE — Menghapus aktivitas dari memori dan DB berdasarkan ID.
  ///
  /// Pemeriksaan ganda (id + userId) mencegah user A menghapus data user B.
  void hapus(String id, String userId) {
    _aktivitas.removeWhere((a) => a.id == id && a.userId == userId);
    notifyListeners();

    // Hapus dari DB secara async
    _db.deleteActivity(id);
  }

  // ===== HELPER =====

  /// Mengonversi objek [AktivitasLari] menjadi Map untuk operasi DB.
  Map<String, dynamic> _aktivitasKeMap(AktivitasLari a) {
    return {
      DatabaseHelper.colActId: a.id,
      DatabaseHelper.colActUserId: a.userId,
      DatabaseHelper.colActJarak: a.jarakKm,
      DatabaseHelper.colActWaktu: a.waktuMenit,
      DatabaseHelper.colActTanggal: a.tanggal.toIso8601String(),
      DatabaseHelper.colActCatatan: a.catatan,
    };
  }
}
