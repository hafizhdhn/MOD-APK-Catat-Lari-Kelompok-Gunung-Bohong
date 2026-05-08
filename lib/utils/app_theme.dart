// File: app_theme.dart
// Konfigurasi tema visual terpusat untuk seluruh aplikasi Catat Lari
// Menggunakan Material 3 dengan TextTheme, ColorScheme, dan komponen yang konsisten

import 'package:flutter/material.dart';

/// Kelas AppTheme menyimpan semua konfigurasi tema aplikasi secara terpusat.
///
/// Semua screen wajib menggunakan tema ini melalui [Theme.of(context)] —
/// tidak boleh ada warna, ukuran font, atau gaya komponen yang di-hardcode di luar sini.
/// Menggunakan [ColorScheme.fromSeed] agar Material 3 menghasilkan palet warna
/// yang harmonis secara otomatis dari satu warna benih.
class AppTheme {
  // Konstruktor private — kelas ini tidak boleh diinstansiasi
  AppTheme._();

  /// Warna benih (seed color) utama — Deep Orange yang energik dan bersemangat.
  /// Cocok untuk aplikasi olahraga/lari karena memancarkan energi dan antusiasme.
  static const Color seedColor = Color(0xFFE64A19);

  /// Warna aksen sekunder — biru gelap untuk kontras yang baik dengan orange
  static const Color accentColor = Color(0xFF1565C0);

  /// Tema terang (light mode) yang digunakan seluruh aplikasi.
  ///
  /// Mencakup konfigurasi lengkap:
  /// - ColorScheme (warna primer, sekunder, permukaan, error)
  /// - TextTheme (heading, body, label, caption)
  /// - AppBar, ElevatedButton, InputDecoration, Card, FAB
  static ThemeData get lightTheme {
    // Buat skema warna otomatis dari seed color menggunakan algoritma Material 3
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      // Aktifkan sistem desain Material 3
      useMaterial3: true,

      // Terapkan color scheme yang dihasilkan dari seed
      colorScheme: colorScheme,

      // ===== TEXT THEME =====
      // Mendefinisikan hierarki tipografi untuk seluruh aplikasi.
      // Menggunakan Roboto (default Flutter) dengan ukuran dan bobot yang konsisten.
      textTheme: TextTheme(
        // Display — teks sangat besar untuk judul splash/hero
        displayLarge: const TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: const TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
        ),

        // Headline — judul halaman dan section utama
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),

        // Title — judul kartu, section, dan AppBar
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),

        // Body — teks konten utama
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),

        // Label — teks kecil untuk badge, chip, dan keterangan
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ===== APP BAR =====
      // AppBar menggunakan warna primary dengan teks/ikon putih
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      // ===== ELEVATED BUTTON =====
      // Tombol utama aplikasi — lebar penuh, sudut membulat, font tebal
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          // Lebar penuh dengan tinggi minimum 52px untuk area ketuk yang nyaman
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          elevation: 2,
        ),
      ),

      // ===== FILLED BUTTON =====
      // Versi solid dari tombol — dipakai untuk CTA di empty state
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ===== TEXT BUTTON =====
      // Tombol teks — dipakai untuk "Batal", "Lupa Password", tautan navigasi
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // ===== OUTLINED BUTTON =====
      // Tombol outlined — dipakai untuk "Keluar dari Akun" di profil
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ===== INPUT DECORATION =====
      // Konfigurasi global untuk semua TextFormField dan TextField di aplikasi
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Latar field sedikit berbeda dari surface agar terlihat
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(77),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // Border lebih tebal dan berwarna primary saat field aktif
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        errorStyle: TextStyle(color: colorScheme.error, fontSize: 12),
      ),

      // ===== CARD =====
      // Konfigurasi kartu — sudut membulat dan elevasi ringan
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surfaceContainerLow,
      ),

      // ===== FLOATING ACTION BUTTON =====
      // FAB menggunakan primaryContainer agar kontras dengan AppBar primary
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ===== SNACK BAR =====
      // Snackbar dengan sudut membulat dan perilaku floating
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      // ===== DIALOG =====
      // Dialog dengan sudut membulat sesuai gaya Material 3
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ===== NAVIGATION BAR =====
      // Bottom Navigation Bar Material 3 — sudah dikonfigurasi secara default
      navigationBarTheme: const NavigationBarThemeData(
        elevation: 3,
      ),

      // Font family — menggunakan Roboto default Flutter
      fontFamily: 'Roboto',
    );
  }
}
