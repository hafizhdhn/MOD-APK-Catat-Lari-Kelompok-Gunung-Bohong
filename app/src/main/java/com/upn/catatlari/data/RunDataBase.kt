package com.upn.catatlari.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.upn.catatlari.model.Run

// 1. Definisikan entitas (tabel) dan versi database
@Database(entities = [Run::class], version = 1, exportSchema = false)
abstract class RunDatabase : RoomDatabase() {

    // 2. Hubungkan DAO yang sudah kamu buat tadi
    abstract fun runDao(): RunDao

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
                    .fallbackToDestructiveMigration() // Jika ganti struktur, data lama dihapus (aman untuk belajar)
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}