package com.upn.catatlari.repository

import com.upn.catatlari.data.UserDao
import com.upn.catatlari.model.User

class UserRepository(private val userDao: UserDao) {
    // Fungsi untuk melakukan register aplikasi
    suspend fun registerUser(user: User) {
        userDao.registerUser(user)
    }

    // Fungsi untuk memperbarui data user (Edit Profile)
    suspend fun updateUser(user: User) {
        userDao.updateUser(user)
    }

    // Fungsi untuk melakukan login aplikasi
    suspend fun loginUser(email: String, password: String): User? {
        return userDao.loginUser(email, password)
    }

    // Fungsi untuk mencari data user berdasarkan email (untuk validasi akun)
    suspend fun getUserByEmail(email: String): User? {
        return userDao.getUserByEmail(email)
    }
}
