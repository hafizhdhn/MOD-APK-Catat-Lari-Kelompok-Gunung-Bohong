// File: login_screen.dart
// Halaman masuk (login) — memvalidasi kredensial terhadap AuthProvider
// dan menyimpan sesi pengguna yang berhasil login

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// LoginScreen menampilkan form email dan password untuk autentikasi pengguna.
///
/// Proses login:
/// 1. Validasi input form (tidak boleh kosong, format benar)
/// 2. Kirim ke AuthProvider.login() untuk dicocokkan dengan akun terdaftar
/// 3. Jika berhasil, GoRouter redirect ke HomeScreen
/// 4. Jika gagal, tampilkan pesan error spesifik dari AuthProvider
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Kunci global untuk memvalidasi seluruh form sekaligus
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengakses nilai input email
  final _emailController = TextEditingController();

  // Controller untuk mengakses nilai input password
  final _passwordController = TextEditingController();

  // Mengontrol apakah karakter password ditampilkan atau disembunyikan
  bool _passwordTerlihat = false;

  // Mengontrol tampilan loading di tombol saat proses login berlangsung
  bool _isLoading = false;

  /// Membersihkan semua controller saat widget dihapus dari widget tree.
  /// Penting untuk mencegah memory leak.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Menangani proses login: validasi → kirim ke AuthProvider → navigasi.
  ///
  /// Flow:
  /// 1. Validasi form — hentikan jika ada error
  /// 2. Tampilkan loading dan tutup keyboard
  /// 3. Simulasi delay jaringan (ganti dengan API call nyata)
  /// 4. Panggil AuthProvider.login() dengan email dan password
  /// 5. Tampilkan error jika gagal, navigasi ke Home jika berhasil
  Future<void> _handleLogin() async {
    // Hentikan jika ada field yang tidak lolos validasi
    if (!_formKey.currentState!.validate()) return;

    // Tutup keyboard virtual agar tidak mengganggu loading
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    // Simulasi delay network request (ganti dengan API call nyata)
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isLoading = false);

    // Validasi kredensial terhadap daftar akun yang terdaftar di AuthProvider
    final colorScheme = Theme.of(context).colorScheme;
    final error = context.read<AuthProvider>().login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (error != null) {
      // Login gagal — tampilkan pesan error spesifik dari AuthProvider
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSnackbar),
          ),
        ),
      );
      return;
    }

    // Login berhasil — AuthProvider sudah memanggil AuthState.masuk() secara internal
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingHalamanH,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.08),

                // ===== HEADER: Logo + Judul + Sub-judul =====
                _buildHeader(colorScheme),

                SizedBox(height: size.height * 0.06),

                // ===== FORM: Email + Password =====
                _buildForm(),

                const SizedBox(height: AppSizes.paddingTerkecil),

                // Tautan lupa password di sisi kanan
                _buildLupaPassword(colorScheme),

                const SizedBox(height: AppSizes.paddingKecil * 2),

                // Tombol login utama dengan state loading
                CustomButton(
                  teks: AppStrings.tombolMasuk,
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  icon: Icons.login_rounded,
                ),

                const SizedBox(height: 32),

                // Tautan ke halaman register
                _buildTautanDaftar(colorScheme),

                const SizedBox(height: AppSizes.paddingKartu),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Membangun bagian header dengan logo ikon, nama app, dan sub-judul.
  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      children: [
        // Lingkaran logo dengan ikon lari
        Container(
          width: AppSizes.ukuranLogoLogin,
          height: AppSizes.ukuranLogoLogin,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha(AppColors.alphaTeksSekunder),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.directions_run_rounded,
            size: AppSizes.ikonBesar,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 20),

        // Nama aplikasi
        Text(
          AppStrings.namaApp,
          style: TextStyle(
            fontSize: AppSizes.teksJudulBesar,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),

        // Sub-judul di bawah nama app
        Text(
          AppStrings.subJudulLogin,
          style: TextStyle(
            fontSize: AppSizes.teksSedang,
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Membangun kolom field input email dan password.
  Widget _buildForm() {
    return Column(
      children: [
        // Field email
        CustomTextField(
          controller: _emailController,
          label: AppStrings.fieldEmail,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.validasiEmailKosong;
            }
            if (!value.contains('@')) return AppStrings.validasiEmailInvalid;
            return null;
          },
        ),
        const SizedBox(height: AppSizes.paddingKartu),

        // Field password dengan toggle visibility
        CustomTextField(
          controller: _passwordController,
          label: AppStrings.fieldPassword,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: !_passwordTerlihat,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordTerlihat
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () =>
                setState(() => _passwordTerlihat = !_passwordTerlihat),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.validasiPasswordKosong;
            }
            if (value.length < 6) return AppStrings.validasiPasswordMinLogin;
            return null;
          },
        ),
      ],
    );
  }

  /// Membangun tautan "Lupa Password?" yang rata kanan.
  Widget _buildLupaPassword(ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          AppStrings.lupaPassword,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Membangun baris tautan ke halaman pendaftaran akun baru.
  Widget _buildTautanDaftar(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.belumPunyaAkun,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.register),
          child: Text(
            AppStrings.daftarSekarang,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
