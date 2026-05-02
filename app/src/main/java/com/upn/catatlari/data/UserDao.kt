package com.upn.catatlari.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.upn.catatlari.model.User

@Dao
interface UserDao {
    // Tambah user baru. IGNORE: Abaikan jika email sudah terdaftar agar tidak crash
    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun registerUser(user: User)

    // Update data user yang sudah ada berdasarkan email
    @Update
    suspend fun updateUser(user: User)

    // Cari user berdasarkan email dan password (untuk fitur Login)
    @Query("SELECT * FROM user_table WHERE email = :email AND password = :password LIMIT 1")
    suspend fun loginUser(email: String, password: String): User?

    // Cari user berdasarkan email saja (untuk cek duplikasi saat daftar)
    @Query("SELECT * FROM user_table WHERE email = :email LIMIT 1")
    suspend fun getUserByEmail(email: String): User?
}
