// File: app_constants.dart
// Kumpulan semua konstanta aplikasi yang dipakai di seluruh codebase
// Memisahkan nilai literal dari logika kode agar mudah diubah dan konsisten

import 'package:flutter/material.dart';

// ===========================================================================
// APP COLORS
// ===========================================================================

/// Kumpulan warna tetap yang digunakan langsung (bukan dari ColorScheme).
///
/// Warna dari tema Material 3 (primary, secondary, error, dll.) tetap diambil
/// dari [Theme.of(context).colorScheme] agar responsif terhadap dark mode.
/// Kelas ini hanya menyimpan warna yang benar-benar hardcoded di seluruh app.
class AppColors {
  // Konstruktor private — kelas ini tidak boleh diinstansiasi
  AppColors._();

  /// Warna oranye untuk kartu statistik Kalori — merepresentasikan "panas"
  static const Color kalori = Colors.orange;

  /// Warna hitam untuk efek bayangan kartu (transparan)
  static const Color bayangan = Colors.black;

  /// Warna putih untuk overlay di atas latar berwarna (banner gradien)
  static const Color overlay = Colors.white;

  // ===== NILAI ALPHA (transparansi 0–255) =====

  /// Alpha sangat lemah — 5% opacity (untuk bayangan halus kartu)
  static const int alphaBayanganHalus = 10;

  /// Alpha lemah — 10% opacity (untuk bayangan kartu statistik)
  static const int alphaBayanganKartu = 13;

  /// Alpha latar ikon — 10% opacity warna aksen
  static const int alphaLatarIkon = 26;

  /// Alpha overlay lemah — 20% opacity (latar kartu di banner)
  static const int alphaOverlayLemah = 51;

  /// Alpha overlay sedang — 30% opacity (fill input field)
  static const int alphaOverlaySedang = 77;

  /// Alpha pemisah — 40% opacity (border, divider)
  static const int alphaPemisah = 102;

  /// Alpha teks sekunder — 70% opacity (sub-teks yang tidak terlalu menonjol)
  static const int alphaTeksSekunder = 153;

  /// Alpha teks normal — 80% opacity (teks di atas latar berwarna)
  static const int alphaTeksNormal = 204;

  /// Alpha teks utama — 70% opacity (teks ikon di banner)
  static const int alphaTeksIkon = 178;
}

// ===========================================================================
// APP STRINGS
// ===========================================================================

/// Kumpulan semua teks/label yang dipakai di seluruh aplikasi.
///
/// Memisahkan string dari kode logika agar mudah diubah (misal: ganti bahasa)
/// dan mencegah duplikasi teks yang sama di banyak tempat.
class AppStrings {
  // Konstruktor private — kelas ini tidak boleh diinstansiasi
  AppStrings._();

  // ===== IDENTITAS APLIKASI =====

  /// Nama resmi aplikasi yang ditampilkan di AppBar dan splash
  static const String namaApp = 'Catat Lari';

  /// Nama kelompok pengembang (ditampilkan di profil)
  static const String namaKelompok = 'Kelompok Gunung Bohong';

  // ===== NAVIGASI & JUDUL HALAMAN =====

  /// Label tab Beranda di Bottom Navigation Bar
  static const String tabBeranda = 'Beranda';

  /// Label tab Profil di Bottom Navigation Bar
  static const String tabProfil = 'Profil';

  /// Judul AppBar halaman profil
  static const String judulProfil = 'Profil Saya';

  /// Judul AppBar halaman register
  static const String judulDaftar = 'Buat Akun Baru';

  // ===== HALAMAN LOGIN =====

  /// Sub-judul di bawah logo di halaman login
  static const String subJudulLogin = 'Masuk ke akun Anda untuk melanjutkan';

  /// Label tombol utama login
  static const String tombolMasuk = 'Masuk';

  /// Teks tombol lupa password
  static const String lupaPassword = 'Lupa Password?';

  /// Teks tautan ke register di bawah form login
  static const String belumPunyaAkun = 'Belum punya akun? ';

  /// Teks tautan yang bisa diklik untuk ke register
  static const String daftarSekarang = 'Daftar Sekarang';

  // ===== HALAMAN REGISTER =====

  /// Judul besar halaman register (bisa multi-baris)
  static const String judulBesarDaftar = 'Bergabung\nBersama Kami';

  /// Sub-judul halaman register
  static const String subJudulDaftar =
      'Buat akun dan mulai catat perjalanan lari Anda';

  /// Label tombol submit register
  static const String tombolDaftar = 'Daftar Sekarang';

  /// Teks tautan kembali ke login
  static const String sudahPunyaAkun = 'Sudah punya akun? ';

  /// Notifikasi sukses setelah register berhasil
  static const String registerBerhasil =
      'Akun berhasil dibuat! Silakan masuk.';

  // ===== LABEL FIELD FORM =====

  /// Label field email di login
  static const String fieldEmail = 'Email';

  /// Label field email di register (lebih deskriptif)
  static const String fieldAlamatEmail = 'Alamat Email';

  /// Label field password
  static const String fieldPassword = 'Password';

  /// Label field konfirmasi password
  static const String fieldKonfirmasiPassword = 'Konfirmasi Password';

  /// Label field nama lengkap
  static const String fieldNamaLengkap = 'Nama Lengkap';

  // ===== PESAN VALIDASI FORM =====

  /// Error: field email kosong
  static const String validasiEmailKosong = 'Email tidak boleh kosong';

  /// Error: format email salah
  static const String validasiEmailInvalid = 'Format email tidak valid';

  /// Error: field password kosong
  static const String validasiPasswordKosong = 'Password tidak boleh kosong';

  /// Error: password terlalu pendek (login — minimal 6 karakter)
  static const String validasiPasswordMinLogin = 'Password minimal 6 karakter';

  /// Error: password terlalu pendek (register — minimal 8 karakter)
  static const String validasiPasswordMinDaftar =
      'Password minimal 8 karakter';

  /// Error: nama kosong
  static const String validasiNamaKosong = 'Nama tidak boleh kosong';

  /// Error: nama terlalu pendek
  static const String validasiNamaMin = 'Nama minimal 3 karakter';

  /// Error: konfirmasi password kosong
  static const String validasiKonfirmasiKosong =
      'Konfirmasi password tidak boleh kosong';

  /// Error: konfirmasi password tidak cocok
  static const String validasiPasswordTidakCocok = 'Password tidak cocok';

  // ===== HOME SCREEN =====

  /// Label section statistik keseluruhan
  static const String statistikKeseluruhan = 'Statistik Keseluruhan';

  /// Label section daftar aktivitas
  static const String aktivitasTerkini = 'Aktivitas Terkini';

  /// Judul tampilan kosong (empty state)
  static const String belumAdaAktivitas = 'Belum Ada Aktivitas';

  /// Pesan di bawah judul empty state
  static const String pesanEmptyAktivitas =
      'Ketuk tombol "Catat Lari" di bawah\nuntuk mencatat sesi lari pertamamu!';

  /// Teks tombol shortcut di empty state
  static const String catatLariSekarang = 'Catat Lari Sekarang';

  /// Label FAB tombol catat lari
  static const String fabCatatLari = 'Catat Lari';

  /// Pesan motivasi jika sudah ada aktivitas
  static const String pesanMotivasi = 'Terus semangat berlari!';

  /// Pesan ajakan jika belum ada aktivitas
  static const String pesanAjakan = 'Mulai catat lari pertamamu hari ini!';

  // ===== LABEL STATISTIK =====

  /// Label statistik total jarak
  static const String totalJarak = 'Total Jarak';

  /// Label statistik total sesi
  static const String totalSesi = 'Total Sesi';

  /// Label statistik rata-rata pace
  static const String avgPace = 'Avg Pace';

  /// Label statistik waktu/durasi
  static const String waktu = 'Waktu';

  /// Label statistik kalori
  static const String kalori = 'Kalori';

  /// Label statistik jarak (versi singkat)
  static const String jarak = 'Jarak';

  /// Label statistik jumlah sesi (versi singkat)
  static const String sesi = 'Sesi';

  /// Badge kategori aktivitas lari
  static const String badgeLari = 'Lari';

  // ===== DIALOG HAPUS =====

  /// Judul dialog konfirmasi hapus
  static const String judulDialogHapus = 'Hapus Aktivitas?';

  /// Notifikasi setelah aktivitas berhasil dihapus
  static const String aktivitasDihapus = 'Aktivitas berhasil dihapus';

  /// Label tombol batal
  static const String tombolBatal = 'Batal';

  /// Label tombol hapus
  static const String tombolHapus = 'Hapus';

  // ===== PROFILE SCREEN =====

  /// Label tombol edit profil
  static const String editProfil = 'Edit Profil';

  /// Judul section pencapaian/statistik
  static const String pencapaianKeseluruhan = 'Pencapaian Keseluruhan';

  /// Judul section badge
  static const String badgePencapaian = 'Badge & Pencapaian';

  /// Label tombol keluar dari akun
  static const String keluarDariAkun = 'Keluar dari Akun';

  /// Pesan konfirmasi dialog keluar
  static const String konfirmasiKeluar =
      'Apakah Anda yakin ingin keluar dari aplikasi?';

  /// Label tombol konfirmasi keluar
  static const String tombolKeluar = 'Keluar';

  // ===== BADGE PENCAPAIAN =====

  static const String badge5k = '5K Pertama';
  static const String badge10k = '10K Club';
  static const String badge5Sesi = '5 Sesi';
  static const String badge10Sesi = '10 Sesi';

  // ===== FORM AKTIVITAS =====

  /// Judul form saat menambah aktivitas baru
  static const String judulFormTambah = 'Catat Aktivitas Lari';

  /// Judul form saat mengedit aktivitas
  static const String judulFormEdit = 'Edit Aktivitas';

  /// Label tombol simpan saat mode tambah
  static const String tombolSimpan = 'Simpan';

  /// Label tombol simpan saat mode edit
  static const String tombolPerbarui = 'Perbarui';

  /// Validasi durasi harus > 0
  static const String validasiDurasi = 'Durasi harus lebih dari 0 menit';

  // ===== WEEKLY STATS =====

  /// Judul widget statistik mingguan
  static const String mingguIni = 'Minggu Ini (7 Hari Terakhir)';
}

// ===========================================================================
// APP SIZES
// ===========================================================================

/// Kumpulan ukuran (padding, margin, font, radius) yang sering dipakai.
///
/// Menyimpan nilai numerik sebagai konstanta agar perubahan ukuran global
/// cukup dilakukan di satu tempat.
class AppSizes {
  // Konstruktor private — kelas ini tidak boleh diinstansiasi
  AppSizes._();

  // ===== PADDING & MARGIN =====

  /// Padding horizontal standar untuk halaman (login, register)
  static const double paddingHalamanH = 24.0;

  /// Padding konten di dalam halaman bertab (home, profile)
  static const double paddingKonten = 20.0;

  /// Padding standar di dalam kartu/container
  static const double paddingKartu = 16.0;

  /// Padding kecil antar elemen
  static const double paddingKecil = 12.0;

  /// Padding sangat kecil
  static const double paddingTerkecil = 8.0;

  // ===== BORDER RADIUS =====

  /// Radius sudut untuk kartu besar (kartu aktivitas, container stats)
  static const double radiusKartu = 16.0;

  /// Radius sudut untuk tombol, input field, dialog
  static const double radiusButton = 12.0;

  /// Radius sudut untuk elemen kecil (kotak ikon, chip kecil)
  static const double radiusKecil = 8.0;

  /// Radius sudut untuk badge pill (berbentuk lonjong)
  static const double radiusBadge = 20.0;

  /// Radius sudut untuk snackbar
  static const double radiusSnackbar = 10.0;

  // ===== ICON SIZES =====

  /// Ukuran ikon besar (ilustrasi di empty state)
  static const double ikonBesar = 50.0;

  /// Ukuran ikon header/logo
  static const double ikonHeader = 50.0;

  /// Ukuran ikon AppBar dan navigasi
  static const double ikonNavbar = 28.0;

  /// Ukuran ikon standar dalam list atau kartu
  static const double ikonStandar = 20.0;

  /// Ukuran ikon di dalam kartu statistik
  static const double ikonKartu = 18.0;

  /// Ukuran ikon kecil (di dalam badge, chip)
  static const double ikonKecil = 14.0;

  /// Ukuran ikon mini (di dalam teks catatan)
  static const double ikonMini = 12.0;

  // ===== FONT SIZES =====

  /// Ukuran teks judul besar (nama app di login)
  static const double teksJudulBesar = 32.0;

  /// Ukuran teks heading (sapaan di banner)
  static const double teksHeading = 24.0;

  /// Ukuran teks sub-heading (judul section)
  static const double teksSub = 20.0;

  /// Ukuran teks normal untuk konten
  static const double teksNormal = 16.0;

  /// Ukuran teks sedang (label, sub-judul)
  static const double teksSedang = 14.0;

  /// Ukuran teks kecil (tanggal kartu, keterangan)
  static const double teksKecil = 13.0;

  /// Ukuran teks label kartu statistik
  static const double teksLabel = 12.0;

  /// Ukuran teks mini (badge, chip)
  static const double teksMini = 11.0;

  // ===== DIMENSI KHUSUS =====

  /// Lebar kartu statistik di scroll horizontal
  static const double lebarKartuStat = 120.0;

  /// Tinggi container scroll horizontal statistik
  static const double tinggiScrollStat = 110.0;

  /// Radius avatar pengguna di AppBar
  static const double radiusAvatarKecil = 18.0;

  /// Ukuran avatar profil besar di halaman profil
  static const double ukuranAvatarBesar = 100.0;

  /// Ukuran ikon logo di halaman login
  static const double ukuranLogoLogin = 90.0;

  /// Blur radius bayangan kartu
  static const double blurBayangan = 8.0;

  /// Blur radius bayangan lebih besar
  static const double blurBayanganBesar = 15.0;
}

// ===========================================================================
// APP ASSETS
// ===========================================================================

/// Kumpulan path ke aset (gambar, ikon, font) yang digunakan aplikasi.
///
/// Saat ini aplikasi belum menggunakan aset gambar eksternal —
/// semua ikon menggunakan Material Icons bawaan Flutter.
class AppAssets {
  // Konstruktor private — kelas ini tidak boleh diinstansiasi
  AppAssets._();

  // Contoh penggunaan ketika ada aset:
  // static const String logoApp = 'assets/images/logo.png';
  // static const String iconLari = 'assets/icons/running.svg';

  // Placeholder — belum ada aset gambar yang digunakan
  // Semua ikon menggunakan Material Icons bawaan Flutter (Icons.xxx)
}
