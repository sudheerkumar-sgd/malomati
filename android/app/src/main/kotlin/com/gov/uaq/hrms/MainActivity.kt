package com.gov.uaq.hrms

import android.os.Process
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {

    private fun isFridaServerRunning(): Boolean {
        val processes = Runtime.getRuntime().exec("ps").inputStream.bufferedReader().readLines()
        return processes.any { it.contains("frida") }
    }

    private fun isTracerPidDetected(): Boolean {
        val tracerPid = File("/proc/${Process.myPid()}/status")
            .readLines()
            .firstOrNull { it.startsWith("TracerPid:") }
            ?.split(":")
            ?.get(1)
            ?.trim()
            ?.toIntOrNull() ?: 0

        return tracerPid != 0
    }

    private fun isXposedPresent(): Boolean {
        return try {
            Class.forName("de.robv.android.xposed.XposedHelpers")
            true
        } catch (e: ClassNotFoundException) {
            false
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "security_check").setMethodCallHandler {
                call, result ->
            when (call.method) {
                "isTampered" -> {
                    val detected = isFridaServerRunning() || isTracerPidDetected() || isXposedPresent()
                    result.success(detected)
                }
                else -> result.notImplemented()
            }
        }
    }

}
