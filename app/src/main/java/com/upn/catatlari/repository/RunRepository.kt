package com.upn.catatlari.repository

import androidx.lifecycle.LiveData
import com.upn.catatlari.data.RunDao
import com.upn.catatlari.model.Run

class RunRepository(private val runDao: RunDao) {

    // Mengambil semua data dari DAO (Room otomatis memberikan data dalam LiveData)
    val allRuns: LiveData<List<Run>> = runDao.getAllRuns()

    // Fungsi untuk menambah data
    suspend fun insert(run: Run) {
        runDao.insert(run)
    }

    // Fungsi untuk mengubah data
    suspend fun update(run: Run) {
        runDao.update(run)
    }

    // Fungsi untuk menghapus data
    suspend fun delete(run: Run) {
        runDao.delete(run)
    }
}