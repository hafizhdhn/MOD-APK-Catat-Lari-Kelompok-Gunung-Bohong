package com.upn.catatlari.view

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.upn.catatlari.databinding.FragmentRegisterBinding
import com.upn.catatlari.model.User
import com.upn.catatlari.viewmodel.UserViewModel

class RegisterFragment : Fragment() {
    // Menghubungkan layout XML fragment_register dengan kode Kotlin
    private lateinit var binding: FragmentRegisterBinding
    // Menginisialisasi ViewModel untuk memproses logika pendaftaran user
    private val userViewModel: UserViewModel by viewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentRegisterBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Observasi hasil pendaftaran
        userViewModel.registrationSuccess.observe(viewLifecycleOwner) { success ->
            if (success) {
                // Jika sukses: Tampilkan pesan dan kembali ke halaman Login
                Toast.makeText(requireContext(), "Registrasi Berhasil! Silakan Login", Toast.LENGTH_SHORT).show()
                findNavController().popBackStack()
            } else {
                // Jika gagal: Beritahu user bahwa email sudah digunakan
                Toast.makeText(requireContext(), "Email sudah terdaftar!", Toast.LENGTH_SHORT).show()
            }
        }
        // Event saat tombol Register diklik
        binding.buttonRegister.setOnClickListener {
            val name = binding.etNameSignup.text.toString().trim()
            val email = binding.etEmailSignup.text.toString().trim()
            val password = binding.etPasswordSignup.text.toString().trim()
            val retypePassword = binding.etRetypePasswordSignup.text.toString().trim()

            // Validasi Input
            if (name.isEmpty() || email.isEmpty() || password.isEmpty() || retypePassword.isEmpty()) {
                Toast.makeText(requireContext(), "Semua kolom harus diisi!", Toast.LENGTH_SHORT).show()
            } else if (password != retypePassword) {
                Toast.makeText(requireContext(), "Password tidak cocok!", Toast.LENGTH_SHORT).show()
            } else {
                // Simpan User Baru (termasuk Nama) ke Database
                val newUser = User(email = email, name = name, password = password)
                userViewModel.register(newUser)
            }
        }
    }
}
