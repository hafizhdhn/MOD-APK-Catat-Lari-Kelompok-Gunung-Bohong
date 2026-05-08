// File: custom_text_field.dart
// Widget input teks kustom yang konsisten dipakai di seluruh form aplikasi
// Menyatukan konfigurasi TextFormField agar tidak duplikasi kode

import 'package:flutter/material.dart';

/// Widget CustomTextField adalah input teks standar aplikasi.
/// Membungkus TextFormField dengan konfigurasi yang sudah diatur.
class CustomTextField extends StatelessWidget {
  // Controller untuk mengakses dan mengontrol nilai teks input
  final TextEditingController controller;

  // Label yang muncul di dalam field sebagai hint
  final String label;

  // Ikon yang ditampilkan di sisi kiri field
  final IconData prefixIcon;

  // Apakah teks disembunyikan (untuk password)
  final bool obscureText;

  // Widget opsional di sisi kanan field (misal: tombol show/hide password)
  final Widget? suffixIcon;

  // Jenis keyboard yang muncul (email, number, text, dll)
  final TextInputType keyboardType;

  // Fungsi validasi input - kembalikan string error jika tidak valid, null jika valid
  final String? Function(String?)? validator;

  // Aksi tombol "enter" pada keyboard virtual
  final TextInputAction textInputAction;

  // Apakah field ini boleh diedit oleh pengguna
  final bool enabled;

  /// Konstruktor CustomTextField.
  /// [controller], [label], [prefixIcon] wajib diisi.
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        // Ikon di sisi kiri field
        prefixIcon: Icon(prefixIcon),
        // Widget di sisi kanan field (opsional)
        suffixIcon: suffixIcon,
      ),
    );
  }
}
