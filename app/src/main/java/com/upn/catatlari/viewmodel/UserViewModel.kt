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
    
    private val _loginResult = MutableLiveData<User?>()
    val loginResult: LiveData<User?> = _loginResult

    private val _registrationSuccess = MutableLiveData<Boolean>()
    val registrationSuccess: LiveData<Boolean> = _registrationSuccess

    private val _updateSuccess = MutableLiveData<Boolean>()
    val updateSuccess: LiveData<Boolean> = _updateSuccess

    init {
        val userDao = RunDatabase.getDatabase(application).userDao()
        repository = UserRepository(userDao)
    }

    fun register(user: User) = viewModelScope.launch(Dispatchers.IO) {
        val existingUser = repository.getUserByEmail(user.email)
        if (existingUser == null) {
            repository.registerUser(user)
            _registrationSuccess.postValue(true)
        } else {
            _registrationSuccess.postValue(false)
        }
    }

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
