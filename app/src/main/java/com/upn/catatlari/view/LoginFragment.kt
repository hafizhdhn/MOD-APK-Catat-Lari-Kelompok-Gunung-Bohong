package com.upn.catatlari.view

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.upn.catatlari.R
import com.upn.catatlari.databinding.FragmentLoginBinding
import com.upn.catatlari.viewmodel.UserViewModel

class LoginFragment : Fragment() {
    // Menghubungkan layout XML dengan kode Kotlin (ViewBinding)
    private lateinit var loginBinding: FragmentLoginBinding

    //Menginisialisasi ViewModel untuk memproses data user
    private val userViewModel: UserViewModel by viewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        // Mengubah layout XML menjadi objek tampilan (view)
        loginBinding = FragmentLoginBinding.inflate(inflater, container, false)
        return loginBinding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Observasi hasil login
        userViewModel.loginResult.observe(viewLifecycleOwner) { user ->
            if (user != null) {
                // Login Berhasil
                val intent = Intent(requireContext(), MainActivity::class.java)
                intent.putExtra("user", user)
                startActivity(intent)
                requireActivity().finish() // Tutup LoginActivity agar tidak bisa kembali ke login
            } else {
                // Login Gagal
                Toast.makeText(requireContext(), "Email atau Password salah!", Toast.LENGTH_SHORT).show()
            }
        }

        //Event saat tombol login diklik
        loginBinding.buttonLogin.setOnClickListener {
            val emailUser = loginBinding.etEmail.text.toString()
            val passwordUser = loginBinding.etPassword.text.toString()

            //Validasi input agar tidak kosong
            if (emailUser.isEmpty() || passwordUser.isEmpty()) {
                Toast.makeText(requireContext(), "Silahkan masukkan email/password!", Toast.LENGTH_SHORT).show()
            } else {
                // Panggil fungsi login di ViewModel (cek ke database)
                userViewModel.login(emailUser, passwordUser)
            }
        }

        // Navigasi ke halaman Register jika belum punya akun
        loginBinding.txtSignup.setOnClickListener {
            findNavController().navigate(R.id.action_loginFragment_to_registerFragment)
        }
    }
}
