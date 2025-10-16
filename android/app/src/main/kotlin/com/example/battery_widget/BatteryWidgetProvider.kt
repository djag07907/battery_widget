package com.example.battery_widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.widget.RemoteViews

class BatteryWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // Perform this loop procedure for each widget
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
    
    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
        super.onEnabled(context)
    }
    
    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
        super.onDisabled(context)
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val batteryInfo = getBatteryInfo(context)
            val views = RemoteViews(context.packageName, R.layout.battery_widget_layout)
            
            // Update battery percentage
            views.setTextViewText(R.id.battery_percentage, "${batteryInfo.level}%")
            
            // Update battery fill based on level and charging status
            val batteryFill: Int
            when {
                batteryInfo.isCharging -> {
                    batteryFill = R.drawable.tall_cell_battery_fill_charging
                    views.setViewVisibility(R.id.charging_indicator, android.view.View.VISIBLE)
                    views.setViewVisibility(R.id.charging_glow, android.view.View.VISIBLE)
                    // Create blue glow effect by setting alpha
                    views.setFloat(R.id.charging_glow, "setAlpha", 0.9f)
                }
                batteryInfo.level <= 30 -> {
                    batteryFill = R.drawable.tall_cell_battery_fill_low
                    views.setViewVisibility(R.id.charging_indicator, android.view.View.GONE)
                    views.setViewVisibility(R.id.charging_glow, android.view.View.GONE)
                }
                batteryInfo.level <= 60 -> {
                    batteryFill = R.drawable.tall_cell_battery_fill_medium
                    views.setViewVisibility(R.id.charging_indicator, android.view.View.GONE)
                    views.setViewVisibility(R.id.charging_glow, android.view.View.GONE)
                }
                else -> {
                    batteryFill = R.drawable.tall_cell_battery_fill_high
                    views.setViewVisibility(R.id.charging_indicator, android.view.View.GONE)
                    views.setViewVisibility(R.id.charging_glow, android.view.View.GONE)
                }
            }
            
            // Set the battery fill drawable
            views.setImageViewResource(R.id.battery_fill, batteryFill)
            
            // Make sure widget doesn't have any click actions
            // Remove any pending intents that might open the app
            
            // Instruct the widget manager to update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        
        private fun getBatteryInfo(context: Context): BatteryInfo {
            val batteryIntent = context.applicationContext.registerReceiver(
                null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            )
            
            val level = batteryIntent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale = batteryIntent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
            val batteryPct = if (level != -1 && scale != -1) {
                (level * 100 / scale.toFloat()).toInt()
            } else {
                0
            }
            
            val status = batteryIntent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                    status == BatteryManager.BATTERY_STATUS_FULL
            
            return BatteryInfo(batteryPct, isCharging)
        }
    }
    
    data class BatteryInfo(val level: Int, val isCharging: Boolean)
}