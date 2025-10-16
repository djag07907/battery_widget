package com.example.battery_widget

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.battery_widget/widget"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeWidget" -> {
                    // Initialize widget
                    updateAllWidgets()
                    result.success("Widget initialized")
                }
                "updateWidget" -> {
                    val batteryLevel = call.argument<Int>("batteryLevel") ?: 0
                    val isCharging = call.argument<Boolean>("isCharging") ?: false
                    val widgetTitle = call.argument<String>("widgetTitle") ?: "Battery"
                    
                    // Update all widget instances
                    updateAllWidgets()
                    result.success("Widget updated")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun updateAllWidgets() {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val thisWidget = ComponentName(this, BatteryWidgetProvider::class.java)
        val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
        
        for (widgetId in allWidgetIds) {
            BatteryWidgetProvider.updateAppWidget(this, appWidgetManager, widgetId)
        }
    }
}
