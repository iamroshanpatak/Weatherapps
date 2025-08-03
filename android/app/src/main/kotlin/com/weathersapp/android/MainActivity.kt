package com.weathersapp.android

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.weathersapp.android/error_handler"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "logError" -> {
                    val error = call.argument<String>("error")
                    Log.e("WeatherApp", "Error: $error")
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
} 