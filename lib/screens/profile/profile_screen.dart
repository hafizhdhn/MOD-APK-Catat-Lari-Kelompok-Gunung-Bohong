// File: profile_screen.dart
// Halaman profil — menampilkan data user yang login dan statistik dari Provider
// Data profil dan statistik sekarang diisolasi per-user via AuthProvider + AktivitasProvider

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/aktivitas_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_routes.dart';

/// ProfileScreen menampilkan profil pengguna yang sedang login.
/// Data bersumber dari AuthProvider (bukan dummy hardcoded) sehingga
/// selalu sinkron dengan akun yang digunakan.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Consumer2 mendengarkan dua provider sekaligus:
    // AuthProvider untuk info user aktif, AktivitasProvider untuk statistik
    return Consumer2<AuthProvider, AktivitasProvider>(
      builder: (context, authProvider, aktivitasProvider, _) {
        final user = authProvider.currentUser;
        final nama = user?.nama ?? 'Pengguna';
        final email = user?.email ?? '-';
        final userId = user?.id ?? '';

        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Profil Saya'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {},
                tooltip: 'Edit Profil',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ===== HEADER: foto + nama + email dari AuthProvider =====
                _buildHeaderProfil(nama, email, colorScheme),

                const SizedBox(height: 20),

                // ===== STATISTIK: dihitung dari AktivitasProvider per-user =====
                _buildStatistikKeseluruhan(aktivitasProvider, colorScheme, userId),

                const SizedBox(height: 20),

                // ===== BADGE PENCAPAIAN =====
                _buildPencapaian(aktivitasProvider, colorScheme, userId),

                const SizedBox(height: 20),

                // ===== MENU PENGATURAN =====
                _buildMenuPengaturan(context, colorScheme),

                const SizedBox(height: 20),

                // ===== TOMBOL KELUAR =====
                _buildTombolKeluar(context, colorScheme),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderProfil(
    String nama,
    String email,
    ColorScheme colorScheme,
  ) {
    // Buat inisial dua huruf dari nama (misal "Ahmad Pelari" → "AP")
    final inisial = nama
        .split(' ')
        .take(2)
        .map((kata) => kata.isNotEmpty ? kata[0] : '')
        .join()
        .toUpperCase();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorScheme.primary, colorScheme.primaryContainer],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    inisial,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: colorScheme.onSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Nama lengkap dari AuthProvider
          Text(
            nama,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 4),

          // Email dari AuthProvider
          Text(
            email,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onPrimary.withAlpha(204),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(102)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.group_rounded, size: 14, color: colorScheme.onPrimary),
                const SizedBox(width: 6),
                Text(
                  'Kelompok Gunung Bohong',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun kartu statistik yang dihitung dari AktivitasProvider — hanya data user ini
  Widget _buildStatistikKeseluruhan(
    AktivitasProvider provider,
    ColorScheme colorScheme,
    String userId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pencapaian Keseluruhan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItemStatistik(
                  nilai: provider.getTotalJarakKmByUser(userId).toStringAsFixed(1),
                  satuan: 'km',
                  label: 'Total Jarak',
                  ikon: Icons.route_rounded,
                  warnaPrimary: colorScheme.primary,
                  colorScheme: colorScheme,
                ),
                Container(
                    height: 50, width: 1, color: colorScheme.outlineVariant),
                _buildItemStatistik(
                  nilai: '${provider.getTotalSesiByUser(userId)}',
                  satuan: 'sesi',
                  label: 'Sesi Lari',
                  ikon: Icons.flag_rounded,
                  warnaPrimary: colorScheme.tertiary,
                  colorScheme: colorScheme,
                ),
                Container(
                    height: 50, width: 1, color: colorScheme.outlineVariant),
                _buildItemStatistik(
                  nilai: '${provider.getTotalKaloriByUser(userId)}',
                  satuan: 'kal',
                  label: 'Kalori',
                  ikon: Icons.local_fire_department_outlined,
                  warnaPrimary: Colors.orange,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemStatistik({
    required String nilai,
    required String satuan,
    required String label,
    required IconData ikon,
    required Color warnaPrimary,
    required ColorScheme colorScheme,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: warnaPrimary.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(ikon, color: warnaPrimary, size: 22),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: nilai,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextSpan(
                text: ' $satuan',
                style: TextStyle(
                    fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        Text(
          label,
          style:
              TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  /// Badge pencapaian — terbuka berdasarkan total jarak dan sesi user ini
  Widget _buildPencapaian(
    AktivitasProvider provider,
    ColorScheme colorScheme,
    String userId,
  ) {
    final totalJarak = provider.getTotalJarakKmByUser(userId);
    final totalSesi = provider.getTotalSesiByUser(userId);

    final daftarBadge = [
      {
        'label': '5K Pertama',
        'ikon': Icons.emoji_events_rounded,
        'tercapai': totalJarak >= 5,
      },
      {
        'label': '10K Club',
        'ikon': Icons.workspace_premium_rounded,
        'tercapai': totalJarak >= 10,
      },
      {
        'label': '5 Sesi',
        'ikon': Icons.military_tech_rounded,
        'tercapai': totalSesi >= 5,
      },
      {
        'label': '10 Sesi',
        'ikon': Icons.calendar_month_rounded,
        'tercapai': totalSesi >= 10,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Badge & Pencapaian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: daftarBadge.map((badge) {
                final tercapai = badge['tercapai'] as bool;
                return Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tercapai
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                      ),
                      child: Icon(
                        badge['ikon'] as IconData,
                        color: tercapai
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant.withAlpha(102),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      badge['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: tercapai
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant.withAlpha(153),
                        fontWeight:
                            tercapai ? FontWeight.w600 : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuPengaturan(BuildContext context, ColorScheme colorScheme) {
    final daftarMenu = [
      {
        'ikon': Icons.person_outline_rounded,
        'judul': 'Edit Profil',
        'subjudul': 'Ubah nama, foto, dan data diri',
      },
      {
        'ikon': Icons.notifications_outlined,
        'judul': 'Notifikasi',
        'subjudul': 'Atur preferensi notifikasi',
      },
      {
        'ikon': Icons.privacy_tip_outlined,
        'judul': 'Privasi',
        'subjudul': 'Kelola data dan privasi akun',
      },
      {
        'ikon': Icons.help_outline_rounded,
        'judul': 'Bantuan',
        'subjudul': 'Pusat bantuan dan FAQ',
      },
      {
        'ikon': Icons.info_outline_rounded,
        'judul': 'Tentang Aplikasi',
        'subjudul': 'Versi 1.0.0 - Catat Lari',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: daftarMenu.asMap().entries.map((entry) {
            final isLast = entry.key == daftarMenu.length - 1;
            final menu = entry.value;
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withAlpha(128),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(menu['ikon'] as IconData,
                        color: colorScheme.primary, size: 20),
                  ),
                  title: Text(
                    menu['judul'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text(
                    menu['subjudul'] as String,
                    style: TextStyle(
                        fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant),
                  onTap: () {},
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: colorScheme.outlineVariant.withAlpha(128),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Membangun tombol keluar dengan dialog konfirmasi
  Widget _buildTombolKeluar(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Keluar dari Akun'),
              content: const Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  onPressed: () {
                    // 1. Tutup dialog
                    Navigator.of(ctx).pop();
                    // 2. Logout via AuthProvider — bersihkan currentUser + AuthState.keluar()
                    context.read<AuthProvider>().logout();
                    // 3. Kembali ke login — GoRouter redirect memblokir akses tanpa login
                    context.go(AppRoutes.login);
                  },
                  child: const Text('Keluar'),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
          side: BorderSide(color: colorScheme.error),
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Keluar dari Akun',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
