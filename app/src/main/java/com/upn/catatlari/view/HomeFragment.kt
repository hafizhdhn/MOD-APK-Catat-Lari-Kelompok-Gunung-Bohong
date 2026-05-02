package com.upn.catatlari.view

import android.app.AlertDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.upn.catatlari.databinding.FragmentHomeBinding
import com.upn.catatlari.model.Run
import com.upn.catatlari.viewmodel.RunViewModel

class HomeFragment : Fragment() {
    // Menghubungkan layout XML fragment_home dengan kode Kotlin
    private lateinit var binding: FragmentHomeBinding
    // Menggunakan activityViewModels agar data history lari sinkron di semua fragment
    private val runViewModel: RunViewModel by activityViewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentHomeBinding.inflate(inflater, container, false)

        // Mengambil data user dari MainActivity untuk menampilkan sapaan di dashboard
        val user = (activity as MainActivity).user
        binding.welcomingTxt.text = "Halo, ${user?.name}"

        // Navigasi ke halaman tambah data lari saat tombol "+" diklik
        binding.floatingBtnAddRun.setOnClickListener {
            // Menggunakan R.id langsung jika HomeFragmentDirections bermasalah
            findNavController().navigate(com.upn.catatlari.R.id.action_homeFragment_to_addRunFragment)
        }

        // Setup Adapter dengan Logika Delete
        val runAdapter = RunAdapter { run ->
            showDeleteConfirmation(run)
        }
        // Mengatur RecyclerView: menentukan bentuk daftar (Linear) dan memasang adapter
        binding.rvRunList.apply {
            layoutManager = LinearLayoutManager(requireContext())
            adapter = runAdapter
        }

        // Memantau perubahan data history lari; jika ada data baru atau dihapus, tampilan otomatis update
        runViewModel.runHistory.observe(viewLifecycleOwner) { runList ->
            runAdapter.setData(runList)
        }

        return binding.root
    }
    // Menampilkan dialog konfirmasi sebelum benar-benar menghapus data dari database
    private fun showDeleteConfirmation(run: Run) {
        AlertDialog.Builder(requireContext())
            .setTitle("Hapus Catatan")
            .setMessage("Apakah Anda yakin ingin menghapus catatan lari tanggal ${run.runDate}?")
            .setPositiveButton("Hapus") { _, _ ->
                runViewModel.deleteRun(run)
                Toast.makeText(requireContext(), "Catatan berhasil dihapus", Toast.LENGTH_SHORT).show()
            }
            .setNegativeButton("Batal", null)
            .show()
    }
}
