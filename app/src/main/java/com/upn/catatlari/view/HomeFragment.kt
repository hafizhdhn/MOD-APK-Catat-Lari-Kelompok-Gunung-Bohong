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

    private lateinit var binding: FragmentHomeBinding
    private val runViewModel: RunViewModel by activityViewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentHomeBinding.inflate(inflater, container, false)

        val user = (activity as MainActivity).user
        binding.welcomingTxt.text = "Halo, ${user?.name}"

        binding.floatingBtnAddRun.setOnClickListener {
            // Menggunakan R.id langsung jika HomeFragmentDirections bermasalah
            findNavController().navigate(com.upn.catatlari.R.id.action_homeFragment_to_addRunFragment)
        }

        // Setup Adapter dengan Logika Delete
        val runAdapter = RunAdapter { run ->
            showDeleteConfirmation(run)
        }

        binding.rvRunList.apply {
            layoutManager = LinearLayoutManager(requireContext())
            adapter = runAdapter
        }

        runViewModel.runHistory.observe(viewLifecycleOwner) { runList ->
            runAdapter.setData(runList)
        }

        return binding.root
    }

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
