// File: activity_card.dart
// Widget kartu untuk satu sesi aktivitas lari
// Menampilkan tanggal, badge kategori, statistik lari, catatan, dan menu aksi

import 'package:flutter/material.dart';

import '../models/aktivitas_lari.dart';
import '../utils/app_constants.dart';

/// AktivitasCard menampilkan satu sesi lari dalam format kartu interaktif.
///
/// Setiap kartu menampilkan:
/// - Tanggal aktivitas (format panjang, misal "Senin, 6 Mei 2026")
/// - Badge kategori "Lari"
/// - Menu popup dengan opsi Edit dan Hapus
/// - Statistik detail: Jarak, Durasi, Pace, Kalori
/// - Catatan opsional dari pengguna
///
/// [onEdit] dipanggil saat pengguna memilih opsi Edit dari menu popup.
/// [onHapus] dipanggil SETELAH pengguna mengkonfirmasi penghapusan di dialog.
/// Parent widget yang bertanggung jawab atas logika hapus yang sebenarnya.
class AktivitasCard extends StatelessWidget {
  /// Data sesi lari yang akan ditampilkan di dalam kartu
  final AktivitasLari aktivitas;

  /// Callback untuk membuka form edit — dipanggil saat opsi "Edit" dipilih
  final VoidCallback onEdit;

  /// Callback untuk menghapus aktivitas — dipanggil SETELAH konfirmasi dialog
  final VoidCallback onHapus;

  const AktivitasCard({
    super.key,
    required this.aktivitas,
    required this.onEdit,
    required this.onHapus,
  });

  /// Memformat tanggal ke format singkat untuk pesan konfirmasi hapus.
  /// Contoh: "6 Mei 2026"
  String _formatTanggalSingkat(DateTime tanggal) {
    const namaBulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  /// Memformat tanggal ke format panjang untuk header kartu.
  /// Contoh: "Senin, 6 Mei 2026"
  String _formatTanggalPanjang(DateTime tanggal) {
    const namaHari = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    const namaBulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    // weekday: 1=Senin, 7=Minggu; dikurangi 1 untuk index list
    final hari = namaHari[tanggal.weekday - 1];
    final bulan = namaBulan[tanggal.month - 1];
    return '$hari, ${tanggal.day} $bulan ${tanggal.year}';
  }

  /// Menampilkan dialog konfirmasi sebelum menghapus aktivitas.
  ///
  /// Dialog menjelaskan aktivitas mana yang akan dihapus dan meminta
  /// konfirmasi pengguna. Jika dikonfirmasi, [onHapus] dipanggil.
  void _tampilkanDialogHapus(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusKartu),
        ),
        title: const Text(AppStrings.judulDialogHapus),
        content: Text(
          'Aktivitas lari ${aktivitas.jarakFormatted} pada '
          '${_formatTanggalSingkat(aktivitas.tanggal)} akan dihapus permanen.',
        ),
        actions: [
          // Tombol batal — tutup dialog tanpa menghapus apa pun
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.tombolBatal),
          ),
          // Tombol hapus — tutup dialog, lalu delegasikan hapus ke parent
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog konfirmasi
              onHapus(); // Beri tahu parent untuk melakukan hapus + snackbar
            },
            child: const Text(AppStrings.tombolHapus),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingKecil),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusKartu),
        boxShadow: [
          BoxShadow(
            color: AppColors.bayangan.withAlpha(AppColors.alphaBayanganHalus),
            blurRadius: AppSizes.blurBayangan,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ===== BARIS ATAS: tanggal + badge + menu popup =====
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingKartu,
              AppSizes.paddingKecil,
              AppSizes.paddingTerkecil,
              0,
            ),
            child: Row(
              children: [
                // Tanggal aktivitas dalam format panjang (kiri)
                Expanded(
                  child: Text(
                    _formatTanggalPanjang(aktivitas.tanggal),
                    style: TextStyle(
                      fontSize: AppSizes.teksKecil,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                // Badge kategori aktivitas — selalu "Lari" di app ini
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingTerkecil,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusBadge),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.directions_run_rounded,
                        size: AppSizes.ikonMini,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.badgeLari,
                        style: TextStyle(
                          fontSize: AppSizes.teksMini,
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu popup: Edit dan Hapus
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: AppSizes.ikonStandar,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.paddingKecil),
                  ),
                  onSelected: (nilai) {
                    if (nilai == 'edit') {
                      // Delegasikan buka form edit ke parent
                      onEdit();
                    } else if (nilai == 'hapus') {
                      // Tampilkan dialog konfirmasi dulu sebelum hapus
                      _tampilkanDialogHapus(context, colorScheme);
                    }
                  },
                  itemBuilder: (_) => [
                    // Opsi: Edit
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined,
                              size: AppSizes.ikonKartu, color: colorScheme.primary),
                          const SizedBox(width: 10),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    // Opsi: Hapus
                    PopupMenuItem(
                      value: 'hapus',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: AppSizes.ikonKartu, color: colorScheme.error),
                          const SizedBox(width: 10),
                          Text(AppStrings.tombolHapus,
                              style: TextStyle(color: colorScheme.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== BARIS STATISTIK: Jarak, Durasi, Pace, Kalori =====
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingKartu,
              AppSizes.paddingKecil,
              AppSizes.paddingKartu,
              AppSizes.paddingKartu,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailStat(
                  ikon: Icons.route_rounded,
                  nilai: aktivitas.jarakFormatted,
                  label: AppStrings.jarak,
                  colorScheme: colorScheme,
                ),
                _buildDetailStat(
                  ikon: Icons.timer_outlined,
                  nilai: aktivitas.waktuFormatted,
                  label: 'Durasi',
                  colorScheme: colorScheme,
                ),
                _buildDetailStat(
                  ikon: Icons.speed_rounded,
                  nilai: aktivitas.paceFormatted,
                  label: 'Pace',
                  colorScheme: colorScheme,
                ),
                _buildDetailStat(
                  ikon: Icons.local_fire_department_outlined,
                  nilai: aktivitas.kaloriFormatted,
                  label: AppStrings.kalori,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),

          // ===== CATATAN (hanya ditampilkan jika pengguna mengisi catatan) =====
          if (aktivitas.catatan.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingKartu,
                0,
                AppSizes.paddingKartu,
                AppSizes.paddingKecil + 2,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notes_rounded,
                    size: AppSizes.ikonKecil,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      aktivitas.catatan,
                      style: TextStyle(
                        fontSize: AppSizes.teksLabel,
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Membangun satu kolom statistik kecil di dalam kartu aktivitas.
  ///
  /// Digunakan untuk menampilkan empat statistik: Jarak, Durasi, Pace, Kalori.
  /// Setiap item terdiri dari ikon + nilai + label yang disusun secara vertikal.
  Widget _buildDetailStat({
    required IconData ikon,
    required String nilai,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Column(
      children: [
        // Ikon kecil berwarna primary
        Icon(ikon, size: AppSizes.ikonKecil + 2, color: colorScheme.primary),
        const SizedBox(height: 4),
        // Nilai statistik dengan font tebal
        Text(
          nilai,
          style: TextStyle(
            fontSize: AppSizes.teksKecil,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        // Label jenis statistik
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.teksMini,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
