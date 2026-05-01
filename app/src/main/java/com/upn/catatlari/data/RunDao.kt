package com.upn.catatlari.data

import androidx.lifecycle.LiveData
import androidx.room.*
import com.upn.catatlari.model.Run

@Dao
interface RunDao {

    // Fungsi untuk menambah data lari
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(run: Run)

    // Fungsi untuk memperbarui data lari (jika ingin fitur edit)
    @Update
    suspend fun update(run: Run)

    // Fungsi untuk menghapus satu data lari tertentu
    @Delete
    suspend fun delete(run: Run)

    // Fungsi untuk mengambil semua data lari
    // Kita gunakan LiveData agar jika ada perubahan data, UI otomatis update
    @Query("SELECT * FROM run_table ORDER BY id DESC")
    fun getAllRuns(): LiveData<List<Run>>

    // Fungsi tambahan: Menghapus semua data lari (opsional)
    @Query("DELETE FROM run_table")
    suspend fun deleteAll()
}