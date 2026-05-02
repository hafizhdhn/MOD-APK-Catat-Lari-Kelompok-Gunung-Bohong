package com.upn.catatlari.view

import android.os.Build
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.upn.catatlari.R
import com.upn.catatlari.model.User

class MainActivity : AppCompatActivity() {
    // Variabel global untuk menyimpan data user yang sedang login agar bisa diakses oleh Fragment lain
    var user: User? = null

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Mengambil data objek User yang dikirim dari LoginFragment melalui Intent
        user = intent.getParcelableExtra("user", User::class.java)

        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        // Mengatur padding agar layout tidak terpotong oleh status bar atau navigasi sistem
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        // 1. Connect BottomNavigation with Navigation Controller
        // Mencari kontainer fragment (NavHost) yang mengatur perpindahan antar halaman
        val navHostFragment = supportFragmentManager.findFragmentById(R.id.nav_host_fragment) as NavHostFragment
        val navController = navHostFragment.navController
        // Menghubungkan tampilan Bottom Navigation dengan sistem navigasi Jetpack
        val bottomNavigation = findViewById<BottomNavigationView>(R.id.bottom_nav_menu)
        bottomNavigation.setupWithNavController(navController)
    }
}