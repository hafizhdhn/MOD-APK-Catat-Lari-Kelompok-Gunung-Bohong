package com.upn.catatlari.view

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.upn.catatlari.R

class AuthActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Mengaktifkan fitur tampilan layar penuh (tepi-ke-tepi) agar UI lebih modern
        enableEdgeToEdge()
        // Menentukan layout XML (activity_auth) yang akan ditampilkan
        setContentView(R.layout.activity_auth)
        // Mengatur padding otomatis agar konten tidak tertutup oleh status bar atau navigasi sistem
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }
}