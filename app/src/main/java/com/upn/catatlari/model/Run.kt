package com.upn.catatlari.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "run_table")
data class Run(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0, // Tambahkan ID sebagai Primary Key
    val runDate: String,
    val runDistance: Int,
    val runDuration: Int
)