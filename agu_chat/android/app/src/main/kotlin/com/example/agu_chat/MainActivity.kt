package com.example.agu_chat

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import com.example.agu_chat.data.MessageHub
import com.example.agu_chat.model.Constanst
import com.example.agu_chat.service.Restarter
import com.example.agu_chat.service.SignalRService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), LifecycleObserver {
    private val CHANNEL = "agu.chat/signalR"

    var sharedpreferences: SharedPreferences? = null

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onAppBackgrounded() {
        Log.d("MyApp", "App in background")
        val myEdit: SharedPreferences.Editor = sharedpreferences!!.edit()
        myEdit.putBoolean("background", true)
        myEdit.commit()
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onAppForegrounded() {
        Log.d("MyApp", "App in foreground")
        val myEdit: SharedPreferences.Editor = sharedpreferences!!.edit()
        myEdit.putBoolean("background", false)
        myEdit.commit()
    }

    /*@OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    fun pause(){
        Log.e("MyApp","My app is Paused")
        Constanst.isBackground = true
    }
    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    fun resume(){
        Log.e("MyApp","My app is Resumed")
    }*/

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedpreferences = getSharedPreferences("REF", Context.MODE_PRIVATE);

        val myEdit: SharedPreferences.Editor = sharedpreferences!!.edit()
        myEdit.putBoolean("background", false)
        myEdit.commit()

        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "startSignalrService") {
                //val token: String = call.arguments as String;
                val token = call.argument<String>("token")
                Constanst.currentUsername = call.argument<String>("currentUsername").toString()
                //Log.i("Token", "token =   " + token)
                startSignalrService(token.toString());
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startSignalrService(token: String) {
        MessageHub.token = token
        SignalRService.token = token
        //start service run in background whether app is killed
        Intent(this, SignalRService::class.java).also { intent ->
            if (!isMyServiceRunning(SignalRService::class.java)) {
                startService(intent)
            }
        }
    }

    private fun isMyServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                Log.i("Service status", "Running")
                return true
            }
        }
        Log.i("Service status", "Not running")
        return false
    }

    override fun onDestroy() {
        //stopService(mServiceIntent)
        val myEdit: SharedPreferences.Editor = sharedpreferences!!.edit()
        myEdit.putBoolean("background", true)
        myEdit.commit()

        val broadcastIntent = Intent()
        broadcastIntent.action = "restartservice"
        broadcastIntent.setClass(this, Restarter::class.java)
        this.sendBroadcast(broadcastIntent)
        super.onDestroy()
    }
}
