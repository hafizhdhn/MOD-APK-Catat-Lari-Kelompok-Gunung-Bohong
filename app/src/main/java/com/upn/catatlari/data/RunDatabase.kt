package com.upn.catatlari.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.upn.catatlari.model.Run
import com.upn.catatlari.model.User

// 1. Definisikan entitas (tabel) dan versi database
// Tambahkan User::class ke dalam entities dan naikkan versi menjadi 2
@Database(entities = [Run::class, User::class], version = 2, exportSchema = false)
abstract class RunDatabase : RoomDatabase() {

    // 2. Hubungkan DAO
    abstract fun runDao(): RunDao
    abstract fun userDao(): UserDao

    //Singleton Pattern: Fungsi untuk menjamin hanya ada satu objek database yang aktif
    companion object {
        @Volatile
        private var INSTANCE: RunDatabase? = null

        // 3. Fungsi untuk mendapatkan database (Singleton)
        fun getDatabase(context: Context): RunDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    RunDatabase::class.java,
                    "run_database"
                )
                    .fallbackToDestructiveMigration() // Aman untuk belajar, data dihapus jika versi naik
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
