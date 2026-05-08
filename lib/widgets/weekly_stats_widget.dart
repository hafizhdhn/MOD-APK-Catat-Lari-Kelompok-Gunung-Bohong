// File: weekly_stats_widget.dart
// Widget ringkasan statistik aktivitas lari dalam 7 hari terakhir
// Ditampilkan di halaman utama sebagai indikator kemajuan mingguan

import 'package:flutter/material.dart';

import '../models/aktivitas_lari.dart';

/// WeeklyStatsWidget menampilkan ringkasan statistik aktivitas lari
/// dalam 7 hari terakhir (termasuk hari ini).
///
/// Widget ini menerima [daftarAktivitas] yang sudah difilter untuk user aktif,
/// kemudian melakukan filter tambahan berdasarkan rentang tanggal 7 hari terakhir.
/// Tiga statistik yang ditampilkan: Total Jarak, Total Waktu, Jumlah Sesi.
class WeeklyStatsWidget extends StatelessWidget {
  /// Daftar aktivitas milik user yang sedang login.
  /// Widget akan memfilter sendiri aktivitas dalam 7 hari terakhir.
  final List<AktivitasLari> daftarAktivitas;

  const WeeklyStatsWidget({super.key, required this.daftarAktivitas});

  /// Mengembalikan daftar aktivitas yang dilakukan dalam 7 hari terakhir.
  ///
  /// Dihitung mundur dari hari ini: hari ini + 6 hari ke belakang.
  /// Tanggal batas awal diatur ke pukul 00:00:00 agar mencakup seluruh hari itu.
  List<AktivitasLari> get _aktivitasMingguIni {
    final sekarang = DateTime.now();
    // Hitung batas awal: 6 hari yang lalu, mulai tengah malam
    final awalMinggu = sekarang.subtract(const Duration(days: 6));
    final batasAwal = DateTime(
      awalMinggu.year,
      awalMinggu.month,
      awalMinggu.day,
    );
    // Filter aktivitas yang tanggalnya tidak lebih awal dari batasAwal
    return daftarAktivitas.where((a) => !a.tanggal.isBefore(batasAwal)).toList();
  }

  /// Jumlah sesi lari yang dilakukan dalam 7 hari terakhir
  int get _sesiMingguIni => _aktivitasMingguIni.length;

  /// Total jarak (km) yang ditempuh dalam 7 hari terakhir
  double get _jarakMingguIni =>
      _aktivitasMingguIni.fold(0.0, (sum, a) => sum + a.jarakKm);

  /// Total durasi (menit) dari semua aktivitas dalam 7 hari terakhir
  int get _waktuMingguIni =>
      _aktivitasMingguIni.fold(0, (sum, a) => sum + a.waktuMenit);

  /// Mengubah total menit menjadi format string yang mudah dibaca.
  ///
  /// Contoh: 90 menit → "1j 30m", 45 menit → "45m", 0 menit → "0m"
  String _formatWaktu(int menit) {
    if (menit == 0) return '0m';
    final jam = menit ~/ 60;
    final sisa = menit % 60;
    if (jam > 0) return '${jam}j ${sisa}m';
    return '${menit}m';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sesi = _sesiMingguIni;
    final jarak = _jarakMingguIni;
    final waktu = _waktuMingguIni;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Latar dengan warna secondary container semi-transparan
          color: colorScheme.secondaryContainer.withAlpha(128),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.secondary.withAlpha(77)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER: label "Minggu Ini" dan badge jumlah sesi =====
            Row(
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: 16,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Minggu Ini (7 Hari Terakhir)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const Spacer(),
                // Badge jumlah sesi — ditampilkan di kanan header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$sesi sesi',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ===== STATISTIK TIGA KOLOM: Jarak | Waktu | Aktivitas =====
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                    label: 'Jarak',
                    nilai: '${jarak.toStringAsFixed(1)} km',
                    colorScheme: colorScheme,
                  ),
                ),
                // Pemisah vertikal antar kolom
                Container(
                  height: 30,
                  width: 1,
                  color: colorScheme.secondary.withAlpha(77),
                ),
                Expanded(
                  child: _buildMiniStat(
                    label: 'Waktu',
                    nilai: _formatWaktu(waktu),
                    colorScheme: colorScheme,
                  ),
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: colorScheme.secondary.withAlpha(77),
                ),
                Expanded(
                  child: _buildMiniStat(
                    label: 'Aktivitas',
                    // Tampilkan tanda "-" jika belum ada aktivitas minggu ini
                    nilai: sesi == 0 ? '-' : '$sesi sesi',
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun satu item statistik mini (nilai + label) dalam tata letak kolom.
  ///
  /// Parameter [nilai] adalah angka yang ditampilkan besar di atas.
  /// Parameter [label] adalah deskripsi singkat di bawah nilai.
  Widget _buildMiniStat({
    required String label,
    required String nilai,
    required ColorScheme colorScheme,
  }) {
    return Column(
      children: [
        // Nilai statistik — font tebal agar menonjol
        Text(
          nilai,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(height: 2),
        // Label jenis statistik — lebih kecil dan transparan
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSecondaryContainer.withAlpha(153),
          ),
        ),
      ],
    );
  }
}
