package com.upn.catatlari.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.upn.catatlari.data.RunDatabase
import com.upn.catatlari.model.User
import com.upn.catatlari.repository.UserRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class UserViewModel(application: Application) : AndroidViewModel(application) {

    private val repository: UserRepository

    // LiveData untuk menampung hasil login (berisi data user atau null)
    private val _loginResult = MutableLiveData<User?>()
    val loginResult: LiveData<User?> = _loginResult

    // LiveData untuk status pendaftaran (true jika berhasil, false jika gagal)
    private val _registrationSuccess = MutableLiveData<Boolean>()
    val registrationSuccess: LiveData<Boolean> = _registrationSuccess

    // LiveData untuk status update profil (true jika berhasil, false jika gagal)
    private val _updateSuccess = MutableLiveData<Boolean>()
    val updateSuccess: LiveData<Boolean> = _updateSuccess

    init {
        // Inisialisasi database dan repository saat ViewModel pertama kali dibuat
        val userDao = RunDatabase.getDatabase(application).userDao()
        repository = UserRepository(userDao)
    }

    // Fungsi registrasi: Cek email dulu, jika belum ada baru simpan ke database
    fun register(user: User) = viewModelScope.launch(Dispatchers.IO) {
        val existingUser = repository.getUserByEmail(user.email)
        if (existingUser == null) {
            repository.registerUser(user)
            _registrationSuccess.postValue(true)
        } else {
            _registrationSuccess.postValue(false)
        }
    }

    // Fungsi login untuk mencocokkan email dan password
    fun login(email: String, password: String) = viewModelScope.launch(Dispatchers.IO) {
        val user = repository.loginUser(email, password)
        _loginResult.postValue(user)
    }

    // Fungsi untuk memperbarui data profile user
    fun updateProfile(user: User) = viewModelScope.launch(Dispatchers.IO) {
        try {
            repository.updateUser(user)
            _updateSuccess.postValue(true)
        } catch (e: Exception) {
            _updateSuccess.postValue(false)
        }
    }
}
