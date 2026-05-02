package com.upn.catatlari.model

import android.os.Parcelable
import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.parcelize.Parcelize

@Parcelize //Memungkinkan objek User dikirim antar halaman (Activity/Fragment) dengan mudah.
@Entity(tableName = "user_table") //Menandakan bahwa kelas ini akan menjadi tabel di database Room dengan nama "user_table"
data class User(
    @PrimaryKey //Menjadikan email sebagai kunci utama (identitas unik), tidak boleh ada email yang sama
    val email: String,
    val name: String,
    val password: String
) : Parcelable
