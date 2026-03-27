package com.upn.catatlari

import android.os.Parcelable

@Parcelize
data class user(val email: String, val password: String) : Parcelable