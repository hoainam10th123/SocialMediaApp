package com.example.agu_chat.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.util.Log

import android.widget.Toast
import com.example.agu_chat.model.Constanst

class Restarter: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.i("Broadcast Listened", "Service tried to stop")
        Toast.makeText(context, "Service restarted", Toast.LENGTH_SHORT).show()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context!!.startForegroundService(Intent(context, SignalRService::class.java))
        } else {
            context!!.startService(Intent(context, SignalRService::class.java))
        }
    }
}