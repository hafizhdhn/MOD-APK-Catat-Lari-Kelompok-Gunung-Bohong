// File: custom_button.dart
// Widget tombol kustom yang dipakai ulang di seluruh aplikasi
// Memastikan tampilan tombol konsisten di semua screen

import 'package:flutter/material.dart';

/// Widget CustomButton adalah tombol utama aplikasi yang dapat dikonfigurasi.
/// Mendukung state loading (menampilkan spinner) saat proses berjalan.
class CustomButton extends StatelessWidget {
  // Teks yang ditampilkan pada tombol
  final String teks;

  // Fungsi yang dipanggil saat tombol ditekan
  final VoidCallback? onPressed;

  // Apakah tombol sedang dalam state loading (menampilkan spinner)
  final bool isLoading;

  // Ikon opsional di sebelah kiri teks
  final IconData? icon;

  /// Konstruktor CustomButton.
  /// [teks] dan [onPressed] wajib diisi.
  const CustomButton({
    super.key,
    required this.teks,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil tema warna dari context agar konsisten dengan tema aplikasi
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      // Nonaktifkan tombol saat loading untuk mencegah klik ganda
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          // Tampilkan spinner saat proses sedang berjalan
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                // Gunakan warna onPrimary agar terlihat di atas tombol
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onPrimary,
                ),
              ),
            )
          // Tampilkan ikon dan teks saat tidak loading
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tampilkan ikon hanya jika diberikan
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(teks),
              ],
            ),
    );
  }
}
