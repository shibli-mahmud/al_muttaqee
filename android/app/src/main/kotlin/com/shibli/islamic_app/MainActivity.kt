package com.shibli.al_muttaqee

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Bridges the three OS settings that decide whether the adhan actually fires
 * on time.
 *
 * flutter_local_notifications already covers notification permission and the
 * exact-alarm permission, but battery-optimisation exclusion has no plugin
 * here, and on the devices this app targets — Xiaomi, Realme, Oppo, Vivo, which
 * are aggressive about background work — it is the setting that most often
 * makes an adhan land ten minutes late. Rather than pull in a whole permissions
 * package for one query and one intent, it is two methods on a channel.
 */
class MainActivity : FlutterActivity() {

    private val channelName = "com.shibli.al_muttaqee/alarm_permissions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isIgnoringBatteryOptimizations" ->
                        result.success(isIgnoringBatteryOptimizations())

                    "requestIgnoreBatteryOptimizations" ->
                        result.success(requestIgnoreBatteryOptimizations())

                    "openBatteryOptimizationSettings" ->
                        result.success(openBatteryOptimizationSettings())

                    "openExactAlarmSettings" ->
                        result.success(openExactAlarmSettings())

                    "openAppNotificationSettings" ->
                        result.success(openAppNotificationSettings())

                    else -> result.notImplemented()
                }
            }
    }

    private fun isIgnoringBatteryOptimizations(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return true
        val power = getSystemService(Context.POWER_SERVICE) as PowerManager
        return power.isIgnoringBatteryOptimizations(packageName)
    }

    /**
     * Shows the system dialog that asks to exempt the app. Google restricts
     * this intent, so it is guarded and falls back to the settings list.
     */
    private fun requestIgnoreBatteryOptimizations(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return true
        if (isIgnoringBatteryOptimizations()) return true
        return try {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
                .setData(Uri.parse("package:$packageName"))
            startActivity(intent)
            true
        } catch (error: Exception) {
            openBatteryOptimizationSettings()
        }
    }

    private fun openBatteryOptimizationSettings(): Boolean = try {
        startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
        true
    } catch (error: Exception) {
        openAppSettings()
    }

    private fun openExactAlarmSettings(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        return try {
            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                .setData(Uri.parse("package:$packageName"))
            startActivity(intent)
            true
        } catch (error: Exception) {
            openAppSettings()
        }
    }

    private fun openAppNotificationSettings(): Boolean = try {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
            startActivity(intent)
            true
        } else {
            openAppSettings()
        }
    } catch (error: Exception) {
        openAppSettings()
    }

    private fun openAppSettings(): Boolean = try {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            .setData(Uri.fromParts("package", packageName, null))
        startActivity(intent)
        true
    } catch (error: Exception) {
        false
    }
}
