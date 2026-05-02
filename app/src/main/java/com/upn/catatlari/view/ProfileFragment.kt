package com.upn.catatlari.view

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.upn.catatlari.R
import com.upn.catatlari.databinding.FragmentProfileBinding

class ProfileFragment : Fragment() {
    // Menghubungkan layout XML fragment_profile dengan kode Kotlin
    private lateinit var binding: FragmentProfileBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentProfileBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Ambil data user dari MainActivity
        val user = (activity as? MainActivity)?.user
        
        // TODO: Tampilkan nama user jika ada TextView di layout
        // binding.txtUserName.text = user?.name

        // Navigasi ke halaman Edit Profile
        binding.btnEditProfile.setOnClickListener {
            findNavController().navigate(R.id.action_profileFragment_to_editProfileFragment)
        }
        // Logika Logout untuk keluar dari aplikasi
        binding.btnLogout.setOnClickListener { 
            // Pindah ke AuthActivity (Halaman Login/Welcome)
            val intent = Intent(requireContext(), AuthActivity::class.java)
            // Menghapus history activity sebelumnya agar tidak bisa di-back ke Profile
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            startActivity(intent)
            requireActivity().finish()
        }
    }
}
