package com.upn.catatlari.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.viewModelScope
import com.upn.catatlari.data.RunDatabase
import com.upn.catatlari.model.Run
import com.upn.catatlari.repository.RunRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

// Kita gunakan AndroidViewModel karena kita butuh "application" untuk memanggil Database
class RunViewModel(application: Application) : AndroidViewModel(application) {

    private val repository: RunRepository
    // LiveData yang akan dipantau oleh UI (Fragment/Activity)
    val runHistory: LiveData<List<Run>>

    init {
        // Inisialisasi Database, DAO, dan Repository
        val runDao = RunDatabase.getDatabase(application).runDao()
        repository = RunRepository(runDao)
        runHistory = repository.allRuns
    }

    // Fungsi Tambah Data (Create)
    fun addRun(run: Run) = viewModelScope.launch(Dispatchers.IO) {
        repository.insert(run)
    }

    // Fungsi Update Data (Update)
    fun updateRun(run: Run) = viewModelScope.launch(Dispatchers.IO) {
        repository.update(run)
    }

    // Fungsi Hapus Data (Delete)
    fun deleteRun(run: Run) = viewModelScope.launch(Dispatchers.IO) {
        repository.delete(run)
    }
}