package com.upn.catatlari.view

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import com.google.android.material.datepicker.MaterialDatePicker
import com.google.android.material.timepicker.MaterialTimePicker
import com.google.android.material.timepicker.TimeFormat
import com.upn.catatlari.databinding.FragmentAddRunBinding
import com.upn.catatlari.model.Run
import com.upn.catatlari.viewmodel.RunViewModel
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import java.util.TimeZone

class AddRunFragment : Fragment() {
    // Menghubungkan layout XML fragment_add_run dengan kode Kotlin
    private lateinit var binding: FragmentAddRunBinding
    private val runViewModel: RunViewModel by activityViewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentAddRunBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // 1. Setup Date Picker
        binding.etDate.setOnClickListener {
            showDatePicker()
        }

        // 2. Setup Time Picker untuk Durasi
        binding.etRunDuration.setOnClickListener {
            showTimePicker()
        }

        // 3. Logika Simpan
        binding.btnSaveRun.setOnClickListener {
            saveRun()
        }
    }

    // Menampilkan kalender untuk memilih tanggal
    private fun showDatePicker() {
        val datePicker = MaterialDatePicker.Builder.datePicker()
            .setTitleText("Pilih Tanggal Lari")
            .setSelection(MaterialDatePicker.todayInUtcMilliseconds())
            .build()

        // Aksi setelah user menekan tombol "OK" pada kalender
        datePicker.addOnPositiveButtonClickListener { selection ->
            val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))
            calendar.timeInMillis = selection
            val format = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
            binding.etDate.setText(format.format(calendar.time))
        }

        datePicker.show(parentFragmentManager, "DATE_PICKER")
    }

    // Menampilkan pemilih waktu untuk menentukan durasi lari
    private fun showTimePicker() {
        val timePicker = MaterialTimePicker.Builder()
            .setTimeFormat(TimeFormat.CLOCK_24H)
            .setHour(0)
            .setMinute(30)
            .setTitleText("Pilih Durasi (Jam:Menit)")
            .build()

        // Format hasil input menjadi string "HH:mm"
        timePicker.addOnPositiveButtonClickListener {
            val formattedTime = String.format(Locale.getDefault(), "%02d:%02d", timePicker.hour, timePicker.minute)
            binding.etRunDuration.setText(formattedTime)
        }

        timePicker.show(parentFragmentManager, "TIME_PICKER")
    }

    // Fungsi untuk memvalidasi dan mengirim data ke ViewModel
    private fun saveRun() {
        val date = binding.etDate.text.toString()
        val distanceStr = binding.etRunDistance.text.toString()
        val durationStr = binding.etRunDuration.text.toString()

        if (date.isEmpty() || distanceStr.isEmpty() || durationStr.isEmpty()) {
            Toast.makeText(requireContext(), "Harap lengkapi semua data!", Toast.LENGTH_SHORT).show()
            return
        }

        try {
            // Konversi durasi ke menit total (contoh: 01:30 -> 90 menit)
            val timeParts = durationStr.split(":")
            val totalMinutes = (timeParts[0].toInt() * 60) + timeParts[1].toInt()
            
            // Konversi jarak ke integer (misal: 5.5 km -> 5500 meter atau biarkan float jika model mendukung)
            // Di model Run, runDistance adalah Int, jadi kita asumsikan meter atau dibulatkan
            val distance = distanceStr.toDouble().toInt() 

            val runInput = Run(
                runDate = date,
                runDuration = totalMinutes,
                runDistance = distance
            )

            runViewModel.addRun(runInput)
            Toast.makeText(requireContext(), "Data lari berhasil disimpan!", Toast.LENGTH_SHORT).show()
            findNavController().popBackStack()
        } catch (e: Exception) {
            Toast.makeText(requireContext(), "Input tidak valid!", Toast.LENGTH_SHORT).show()
        }
    }
}
