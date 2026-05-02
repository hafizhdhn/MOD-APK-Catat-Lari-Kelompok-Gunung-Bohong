package com.upn.catatlari.view

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.upn.catatlari.databinding.ItemRunBinding
import com.upn.catatlari.model.Run

class RunAdapter(private val onDeleteClick: (Run) -> Unit) : RecyclerView.Adapter<RunAdapter.RunViewHolder>() {
    // Menyimpan daftar data lari yang akan ditampilkan di RecyclerView
    private var runList = mutableListOf<Run>()
    // Fungsi untuk memperbarui data di adapter dan memberitahu UI untuk refresh tampilan
    fun setData(runItems: List<Run>) {
        runList.clear()
        runList.addAll(runItems)
        notifyDataSetChanged()
    }
    // Membuat tampilan item baru (berdasarkan layout item_run.xml)
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RunViewHolder =
        RunViewHolder(ItemRunBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    // Menghubungkan data dari runList ke dalam ViewHolder (tampilan item) sesuai posisinya
    override fun onBindViewHolder(holder: RunViewHolder, position: Int) = holder.bind(runList[position])
    // Menentukan jumlah item yang akan ditampilkan dalam daftar
    override fun getItemCount(): Int = runList.size
    // Kelas untuk mengelola komponen UI di dalam setiap baris daftar
    inner class RunViewHolder(private val binding: ItemRunBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(run: Run) {
            // Menampilkan data tanggal, jarak, dan durasi ke TextView
            binding.txtRunDate.text = run.runDate
            binding.txtRunDistance.text = "${run.runDistance} KM"
            binding.txtRunDuration.text = "${run.runDuration} Menit"

            // Event saat tombol hapus di dalam item diklik
            binding.btnDeleteRun.setOnClickListener {
                // Mengirim data 'run' kembali ke HomeFragment untuk diproses hapus
                onDeleteClick(run)
            }
        }
    }
}
