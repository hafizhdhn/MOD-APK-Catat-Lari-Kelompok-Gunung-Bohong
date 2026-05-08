// File: register_screen.dart
// Halaman pendaftaran akun baru — menyimpan akun ke AuthProvider
// Memvalidasi duplikat email dan mengarahkan ke login setelah berhasil

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// RegisterScreen adalah halaman pendaftaran akun baru.
///
/// Pengguna mengisi: nama lengkap, email, password, konfirmasi password.
/// Setelah submit:
/// 1. Validasi form (format, panjang, kecocokan password)
/// 2. Cek duplikat email via AuthProvider.register()
/// 3. Jika berhasil → navigasi ke login dengan notifikasi sukses
/// 4. Jika gagal (email duplikat) → tampilkan pesan error
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

/// State untuk RegisterScreen — mengelola logika form pendaftaran.
class _RegisterScreenState extends State<RegisterScreen> {
  // Kunci global untuk memvalidasi seluruh form sekaligus
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field nama lengkap
  final _namaController = TextEditingController();

  // Controller untuk field email
  final _emailController = TextEditingController();

  // Controller untuk field password
  final _passwordController = TextEditingController();

  // Controller untuk field konfirmasi password
  final _konfirmasiPasswordController = TextEditingController();

  // Mengontrol visibilitas teks pada field password
  bool _passwordTerlihat = false;

  // Mengontrol visibilitas teks pada field konfirmasi password
  bool _konfirmasiTerlihat = false;

  // Mengontrol state loading pada tombol daftar
  bool _isLoading = false;

  /// Membersihkan semua controller saat widget dihapus dari widget tree.
  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  /// Menangani proses pendaftaran: validasi → simpan ke AuthProvider → navigasi.
  ///
  /// Flow:
  /// 1. Validasi form — hentikan jika ada error
  /// 2. Tampilkan loading dan tutup keyboard
  /// 3. Simulasi delay jaringan
  /// 4. Panggil AuthProvider.register() untuk cek duplikat dan simpan akun
  /// 5. Tampilkan error jika gagal (email duplikat), navigasi ke login jika berhasil
  Future<void> _handleDaftar() async {
    // Hentikan jika ada field yang tidak lolos validasi
    if (!_formKey.currentState!.validate()) return;

    // Tutup keyboard virtual
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    // Simulasi proses registrasi ke server
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isLoading = false);

    // Daftarkan akun baru — AuthProvider mengecek duplikat email secara internal
    final colorScheme = Theme.of(context).colorScheme;
    final error = context.read<AuthProvider>().register(
      _namaController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (error != null) {
      // Registrasi gagal — tampilkan pesan error (misal: email sudah dipakai)
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

    // Registrasi berhasil — tampilkan notifikasi dan arahkan ke login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppStrings.registerBerhasil),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSnackbar),
        ),
      ),
    );

    // Navigasi ke login — GoRouter tidak menumpuk rute lama
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // AppBar dengan tombol kembali ke login
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppRoutes.login),
        ),
        title: const Text(AppStrings.judulDaftar),
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingHalamanH,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.02),

                // ===== HEADER: Ikon + Judul + Sub-judul =====
                _buildHeader(colorScheme),

                SizedBox(height: size.height * 0.04),

                // ===== FORM: Nama, Email, Password, Konfirmasi =====
                _buildForm(),

                const SizedBox(height: 28),

                // Tombol submit pendaftaran
                CustomButton(
                  teks: AppStrings.tombolDaftar,
                  onPressed: _handleDaftar,
                  isLoading: _isLoading,
                  icon: Icons.person_add_rounded,
                ),

                const SizedBox(height: AppSizes.paddingKartu),

                // Tautan kembali ke login
                _buildTautanLogin(colorScheme),

                const SizedBox(height: AppSizes.paddingKartu),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Membangun bagian header dengan ikon aksen, judul, dan sub-judul.
  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ikon kecil sebagai aksen visual di pojok kiri atas
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
          child: Icon(
            Icons.directions_run_rounded,
            color: colorScheme.onPrimaryContainer,
            size: 28,
          ),
        ),

        const SizedBox(height: AppSizes.paddingKartu),

        // Judul besar halaman (multi-baris)
        Text(
          AppStrings.judulBesarDaftar,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            height: 1.2,
          ),
        ),

        const SizedBox(height: AppSizes.paddingTerkecil),

        // Sub-judul ajakan
        Text(
          AppStrings.subJudulDaftar,
          style: TextStyle(
            fontSize: AppSizes.teksSedang,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Membangun semua field input form pendaftaran.
  Widget _buildForm() {
    return Column(
      children: [
        // Field nama lengkap
        CustomTextField(
          controller: _namaController,
          label: AppStrings.fieldNamaLengkap,
          prefixIcon: Icons.person_outline_rounded,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.validasiNamaKosong;
            }
            if (value.trim().length < 3) return AppStrings.validasiNamaMin;
            return null;
          },
        ),

        const SizedBox(height: AppSizes.paddingKartu),

        // Field email
        CustomTextField(
          controller: _emailController,
          label: AppStrings.fieldAlamatEmail,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.validasiEmailKosong;
            }
            // Validasi format email dengan regex sederhana
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return AppStrings.validasiEmailInvalid;
            }
            return null;
          },
        ),

        const SizedBox(height: AppSizes.paddingKartu),

        // Field password dengan toggle show/hide
        CustomTextField(
          controller: _passwordController,
          label: AppStrings.fieldPassword,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: !_passwordTerlihat,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordTerlihat
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () =>
                setState(() => _passwordTerlihat = !_passwordTerlihat),
          ),
          // Password minimal 8 karakter untuk keamanan yang lebih baik
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.validasiPasswordKosong;
            }
            if (value.length < 8) return AppStrings.validasiPasswordMinDaftar;
            return null;
          },
        ),

        const SizedBox(height: AppSizes.paddingKartu),

        // Field konfirmasi password — harus cocok dengan password di atas
        CustomTextField(
          controller: _konfirmasiPasswordController,
          label: AppStrings.fieldKonfirmasiPassword,
          prefixIcon: Icons.lock_person_outlined,
          obscureText: !_konfirmasiTerlihat,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _konfirmasiTerlihat
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () =>
                setState(() => _konfirmasiTerlihat = !_konfirmasiTerlihat),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.validasiKonfirmasiKosong;
            }
            // Cocokkan dengan nilai field password
            if (value != _passwordController.text) {
              return AppStrings.validasiPasswordTidakCocok;
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Membangun baris tautan untuk kembali ke halaman login.
  Widget _buildTautanLogin(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.sudahPunyaAkun,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.login),
          child: Text(
            AppStrings.tombolMasuk,
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
