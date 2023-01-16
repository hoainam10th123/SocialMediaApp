package com.example.agu_chat

import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import com.example.agu_chat.service.SignalRService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class CallingActivity: FlutterActivity() {
    lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_calling)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "agu.chat/signalR")
        methodChannel.setMethodCallHandler {
                call, result ->
            if (call.method == "startSignalrService") {

            } else {
                result.notImplemented()
            }
        }
    }

    fun answerCalling(view: View?) {
        SignalRService.stopAudio()
        Log.i("Channel Tag", "channel ${SignalRService.channelName}")
        methodChannel.invokeMethod("RecieveCallingScreen", SignalRService.channelName)
    }
}