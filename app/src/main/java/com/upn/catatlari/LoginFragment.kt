package com.upn.catatlari

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.upn.catatlari.databinding.FragmentLoginBinding

class LoginFragment : Fragment() {

    private lateinit var loginBinding: FragmentLoginBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        loginBinding = FragmentLoginBinding.inflate(
            inflater,
            container,
            false
        )

        return loginBinding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        loginBinding.buttonLogin.setOnClickListener {
            val emailUser = loginBinding.etEmail.text.toString()
            val passwordUser = loginBinding.etPassword.text.toString()

            if (emailUser.isEmpty() || passwordUser.isEmpty())
                Toast.makeText(requireContext(), "Silahkan masukkan email/password, bro!", Toast.LENGTH_SHORT).show()
            else {
                // jika password salah, muncul pesan error
                if (passwordUser != "123456")
                    Toast.makeText(requireContext(), "Password Anda salah!", Toast.LENGTH_SHORT).show()
                // jika password benar, maka berpindah ke MainActivity
                else {
                    val userLogin = user(email = emailUser, password= passwordUser)
                    // berpindah ke MainActivity
                    val intent = Intent(requireContext(), MainActivity::class.java)
                    startActivity(intent)
                }
            }

        }
    }
}