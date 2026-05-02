package com.upn.catatlari.view

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.upn.catatlari.databinding.FragmentEditProfileBinding
import com.upn.catatlari.viewmodel.UserViewModel

class EditProfileFragment : Fragment() {
    // Menghubungkan layout XML fragment_edit_profile dengan kode Kotlin
    private lateinit var binding: FragmentEditProfileBinding
    // Menginisialisasi ViewModel untuk memproses pembaruan data user
    private val userViewModel: UserViewModel by viewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentEditProfileBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Ambil data user saat ini dari MainActivity
        val currentUser = (activity as? MainActivity)?.user

        // Tampilkan data lama di EditText
        currentUser?.let {
            binding.etEditName.setText(it.name)
            // Password biasanya tidak ditampilkan secara plain, tapi untuk kemudahan kita tampilkan atau biarkan kosong
            binding.etEditPassword.setText(it.password)
        }

        // Observasi hasil update
        userViewModel.updateSuccess.observe(viewLifecycleOwner) { success ->
            if (success) {
                Toast.makeText(requireContext(), "Profil berhasil diperbarui!", Toast.LENGTH_SHORT).show()
                
                // Update data user di MainActivity agar sinkron
                (activity as? MainActivity)?.user = currentUser?.copy(
                    name = binding.etEditName.text.toString(),
                    password = binding.etEditPassword.text.toString()
                )
                
                findNavController().popBackStack()
            } else {
                Toast.makeText(requireContext(), "Gagal memperbarui profil!", Toast.LENGTH_SHORT).show()
            }
        }
        // Logika saat tombol simpan profil diklik
        binding.btnSaveProfile.setOnClickListener {
            val newName = binding.etEditName.text.toString().trim()
            val newPassword = binding.etEditPassword.text.toString().trim()

            // Validasi: Memastikan input tidak hanya spasi atau kosong
            if (newName.isEmpty() || newPassword.isEmpty()) {
                Toast.makeText(requireContext(), "Nama dan Password tidak boleh kosong!", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            // Jika user ditemukan, buat salinan data baru dan kirim ke database melalui ViewModel
            if (currentUser != null) {
                val updatedUser = currentUser.copy(name = newName, password = newPassword)
                userViewModel.updateProfile(updatedUser)
            }
        }
    }
}
