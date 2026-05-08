// File: weekly_stats_widget.dart
// Widget ringkasan statistik aktivitas lari dalam 7 hari terakhir
// Ditampilkan di halaman utama sebagai indikator kemajuan mingguan

import 'package:flutter/material.dart';

import '../models/aktivitas_lari.dart';
import '../utils/app_constants.dart';

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
    final batasAwal = DateTime(awalMinggu.year, awalMinggu.month, awalMinggu.day);
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
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingKonten,
        AppSizes.paddingKartu,
        AppSizes.paddingKonten,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingKartu),
        decoration: BoxDecoration(
          // Latar dengan warna secondary container semi-transparan
          color: colorScheme.secondaryContainer.withAlpha(128),
          borderRadius: BorderRadius.circular(AppSizes.radiusKartu),
          border: Border.all(
            color: colorScheme.secondary.withAlpha(AppColors.alphaOverlaySedang),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER: label "Minggu Ini" dan badge jumlah sesi =====
            Row(
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: AppSizes.ikonKartu,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: AppSizes.paddingTerkecil),
                Text(
                  AppStrings.mingguIni,
                  style: TextStyle(
                    fontSize: AppSizes.teksSedang,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const Spacer(),
                // Badge jumlah sesi — ditampilkan di kanan header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingTerkecil,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withAlpha(51),
                    borderRadius: BorderRadius.circular(AppSizes.paddingKecil),
                  ),
                  child: Text(
                    '$sesi sesi',
                    style: TextStyle(
                      fontSize: AppSizes.teksMini,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.paddingKecil),

            // ===== STATISTIK TIGA KOLOM: Jarak | Waktu | Aktivitas =====
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                    label: AppStrings.jarak,
                    nilai: '${jarak.toStringAsFixed(1)} km',
                    colorScheme: colorScheme,
                  ),
                ),
                // Pemisah vertikal antar kolom
                Container(
                  height: 30,
                  width: 1,
                  color: colorScheme.secondary.withAlpha(AppColors.alphaOverlaySedang),
                ),
                Expanded(
                  child: _buildMiniStat(
                    label: AppStrings.waktu,
                    nilai: _formatWaktu(waktu),
                    colorScheme: colorScheme,
                  ),
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: colorScheme.secondary.withAlpha(AppColors.alphaOverlaySedang),
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
            fontSize: AppSizes.teksNormal,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(height: 2),
        // Label jenis statistik — lebih kecil dan transparan
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.teksMini,
            color: colorScheme.onSecondaryContainer.withAlpha(
              AppColors.alphaTeksSekunder,
            ),
          ),
        ),
      ],
    );
  }
}
