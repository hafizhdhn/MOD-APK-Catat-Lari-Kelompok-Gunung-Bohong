// File: home_screen.dart
// Halaman utama aplikasi Catat Lari
// Menampilkan sapaan, statistik lari per-user, dan daftar aktivitas lengkap dengan CRUD

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/aktivitas_lari.dart';
import '../../providers/aktivitas_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_routes.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/weekly_stats_widget.dart';
import 'form_aktivitas.dart';

/// HomeScreen adalah halaman utama yang menampilkan:
/// 1. Banner sapaan dengan statistik ringkasan
/// 2. Widget statistik 7 hari terakhir
/// 3. Baris kartu statistik keseluruhan (scroll horizontal)
/// 4. Daftar semua aktivitas lari atau tampilan kosong jika belum ada data
///
/// Semua data bersumber dari AuthProvider (data user) dan AktivitasProvider
/// (data aktivitas), sehingga UI otomatis diperbarui saat data berubah.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Membuka modal bottom sheet berisi form untuk tambah atau edit aktivitas.
  ///
  /// [aktivitasYangDiEdit] = null → mode tambah aktivitas baru.
  /// [aktivitasYangDiEdit] = objek aktivitas → mode edit dengan form pre-filled.
  void _tampilkanForm(BuildContext context, {AktivitasLari? aktivitasYangDiEdit}) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true agar sheet bisa mengisi lebih dari 50% layar
      isScrollControlled: true,
      // useSafeArea: true agar tidak tertutup notch atau status bar
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FormAktivitas(aktivitasYangDiEdit: aktivitasYangDiEdit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Consumer2 mendengarkan dua provider sekaligus.
    // Rebuild otomatis terjadi saat data user atau aktivitas berubah.
    return Consumer2<AuthProvider, AktivitasProvider>(
      builder: (context, authProvider, aktivitasProvider, _) {
        final user = authProvider.currentUser;
        // user dijamin tidak null di sini karena GoRouter sudah guard login
        final userId = user!.id;
        final namaDepan = user.nama.split(' ').first;
        final inisial = user.nama.isNotEmpty ? user.nama[0].toUpperCase() : 'U';

        // Ambil hanya aktivitas milik user yang sedang login, urut terbaru
        final daftarAktivitas = aktivitasProvider.getAktivitasByUser(userId);

        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest,
          appBar: _buildAppBar(context, colorScheme, inisial),
          body: RefreshIndicator(
            onRefresh: () async {
              // Simulasi refresh — di app nyata ini akan fetch ulang dari server
              await Future.delayed(const Duration(milliseconds: 500));
            },
            color: colorScheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ===== 1. BANNER SAPAAN + RINGKASAN STATISTIK =====
                SliverToBoxAdapter(
                  child: _buildBannerHeader(
                    colorScheme,
                    namaDepan,
                    aktivitasProvider,
                    userId,
                  ),
                ),

                // ===== 2. STATISTIK 7 HARI TERAKHIR =====
                SliverToBoxAdapter(
                  child: WeeklyStatsWidget(daftarAktivitas: daftarAktivitas),
                ),

                // ===== 3. LABEL "STATISTIK KESELURUHAN" =====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      'Statistik Keseluruhan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                // ===== 4. BARIS KARTU STATISTIK (scroll horizontal) =====
                SliverToBoxAdapter(
                  child: _buildStatistikRow(colorScheme, aktivitasProvider, userId),
                ),

                // ===== 5. HEADER "AKTIVITAS TERKINI" + BADGE JUMLAH =====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 4, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Aktivitas Terkini',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        // Badge jumlah sesi — hanya ditampilkan jika ada data
                        if (daftarAktivitas.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${daftarAktivitas.length} sesi',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ===== 6. DAFTAR AKTIVITAS atau EMPTY STATE =====
                if (daftarAktivitas.isEmpty)
                  // Tampilkan ilustrasi kosong jika belum ada data
                  SliverFillRemaining(
                    child: _buildEmptyState(context, colorScheme),
                  )
                else
                  // Tampilkan daftar AktivitasCard menggunakan widget yang diekstrak
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final aktivitas = daftarAktivitas[index];
                          return AktivitasCard(
                            aktivitas: aktivitas,
                            // Buka form edit dengan data aktivitas yang sudah ada
                            onEdit: () => _tampilkanForm(
                              context,
                              aktivitasYangDiEdit: aktivitas,
                            ),
                            // Hapus aktivitas — dipanggil setelah user konfirmasi di dialog
                            onHapus: () {
                              context
                                  .read<AktivitasProvider>()
                                  .hapus(aktivitas.id, userId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Aktivitas berhasil dihapus'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: daftarAktivitas.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ===== FAB: Tombol Catat Lari Baru =====
          floatingActionButton: FloatingActionButton.extended(
            // Buka form tambah aktivitas baru (aktivitasYangDiEdit = null)
            onPressed: () => _tampilkanForm(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Catat Lari',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  /// Membangun AppBar dengan logo, judul, notifikasi, dan avatar user.
  ///
  /// [inisial] adalah huruf pertama nama user yang ditampilkan di avatar.
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
    String inisial,
  ) {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.directions_run_rounded, color: colorScheme.onPrimary),
          const SizedBox(width: 8),
          const Text('Catat Lari'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifikasi',
        ),
        // Avatar dengan inisial nama — ketuk untuk buka halaman profil
        GestureDetector(
          onTap: () => context.go(AppRoutes.profile),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                inisial,
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Membangun banner gradien bagian atas halaman.
  ///
  /// Berisi sapaan personal dengan nama user dan ringkasan tiga statistik:
  /// Total Jarak, Total Sesi, dan Rata-rata Pace.
  Widget _buildBannerHeader(
    ColorScheme colorScheme,
    String namaDepan,
    AktivitasProvider provider,
    String userId,
  ) {
    final totalSesi = provider.getTotalSesiByUser(userId);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // Gradien dari warna primary ke tertiary untuk tampilan dinamis
          colors: [colorScheme.primary, colorScheme.tertiary],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks sapaan personal
          Text(
            'Halo, $namaDepan! 👋',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          // Pesan motivasi — berbeda tergantung apakah sudah ada aktivitas
          Text(
            totalSesi == 0
                ? 'Mulai catat lari pertamamu hari ini!'
                : 'Terus semangat berlari!',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onPrimary.withAlpha(204),
            ),
          ),
          const SizedBox(height: 20),

          // Kartu ringkasan tiga statistik utama di dalam banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // Latar putih transparan agar terlihat di atas gradien
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(77)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildRingkasanItem(
                    label: 'Total Jarak',
                    nilai: provider.getTotalJarakFormattedByUser(userId),
                    ikon: Icons.route_rounded,
                    warna: colorScheme.onPrimary,
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withAlpha(102),
                ),
                Expanded(
                  child: _buildRingkasanItem(
                    label: 'Total Sesi',
                    nilai: '${totalSesi}x',
                    ikon: Icons.flag_rounded,
                    warna: colorScheme.onPrimary,
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withAlpha(102),
                ),
                Expanded(
                  child: _buildRingkasanItem(
                    label: 'Avg Pace',
                    nilai: provider.getAvgPaceFormattedByUser(userId),
                    ikon: Icons.speed_rounded,
                    warna: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun satu item ringkasan statistik di dalam banner.
  ///
  /// Terdiri dari ikon kecil, nilai, dan label yang disusun vertikal.
  Widget _buildRingkasanItem({
    required String label,
    required String nilai,
    required IconData ikon,
    required Color warna,
  }) {
    return Column(
      children: [
        Icon(ikon, color: warna.withAlpha(204), size: 20),
        const SizedBox(height: 4),
        Text(
          nilai,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: warna,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: warna.withAlpha(178),
          ),
        ),
      ],
    );
  }

  /// Membangun baris kartu statistik keseluruhan yang dapat di-scroll horizontal.
  ///
  /// Menggunakan widget [StatsCard] untuk setiap kartu statistik.
  /// Menampilkan 4 statistik: Jarak, Waktu, Kalori, dan Sesi.
  Widget _buildStatistikRow(
    ColorScheme colorScheme,
    AktivitasProvider provider,
    String userId,
  ) {
    // Ambil total waktu sekali saja untuk dipakai di format waktu
    final totalWaktuMenit = provider.getTotalWaktuMenitByUser(userId);

    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        children: [
          // Kartu Jarak
          StatsCard(
            label: 'Jarak',
            nilai: provider.getTotalJarakFormattedByUser(userId),
            ikon: Icons.map_outlined,
            warna: colorScheme.primary,
          ),
          // Kartu Waktu — format jam+menit jika >= 60 menit
          StatsCard(
            label: 'Waktu',
            nilai: totalWaktuMenit >= 60
                ? '${totalWaktuMenit ~/ 60}j ${totalWaktuMenit % 60}m'
                : '${totalWaktuMenit}m',
            ikon: Icons.timer_outlined,
            warna: colorScheme.tertiary,
          ),
          // Kartu Kalori — warna oranye untuk kesan "panas"
          StatsCard(
            label: 'Kalori',
            nilai: '${provider.getTotalKaloriByUser(userId)}',
            ikon: Icons.local_fire_department_outlined,
            warna: Colors.orange,
          ),
          // Kartu Sesi
          StatsCard(
            label: 'Sesi',
            nilai: '${provider.getTotalSesiByUser(userId)}x',
            ikon: Icons.repeat_rounded,
            warna: colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  /// Membangun tampilan kosong (empty state) saat belum ada aktivitas.
  ///
  /// Menampilkan ilustrasi ikon besar, teks penjelasan, dan tombol shortcut
  /// untuk langsung membuka form pencatatan aktivitas baru.
  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon ilustrasi besar di lingkaran
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_run_rounded,
                size: 50,
                color: colorScheme.primary.withAlpha(153),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum Ada Aktivitas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ketuk tombol "Catat Lari" di bawah\nuntuk mencatat sesi lari pertamamu!',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Tombol shortcut — alternatif selain menekan FAB
            FilledButton.icon(
              onPressed: () => _tampilkanForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Catat Lari Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
