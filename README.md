# Battery Widget for Grandma 🔋

A simple, easy-to-read battery widget designed specifically for elderly users, with large text and clear battery indicators.

## Features

- **Large, Clear Display**: Easy-to-read battery percentage in large text
- **Visual Battery Icons**: Different icons showing battery level at a glance
- **Charging Status**: Shows when the phone is charging
- **Customizable Settings**: Toggle percentage/charging status display
- **Home Screen Widget**: Display battery info directly on home screen
- **Lock Screen Support**: Available on lock screen (device dependent)
- **Redmi/MIUI Optimized**: Enhanced compatibility with Xiaomi devices

## Installation Instructions

### For the Tech-Savvy Helper:

1. **Build the APK:**
   ```bash
   fvm flutter build apk --release
   ```

2. **Install on Grandma's Phone:**
   - Transfer the APK to her phone
   - Enable "Install from Unknown Sources" in Settings
   - Install the APK

### For Grandma:

1. **Add Widget to Home Screen:**
   - Long press on empty space on home screen
   - Tap "Widgets" 
   - Look for "Battery Widget"
   - Drag it to desired location on home screen

2. **Customize Widget (if needed):**
   - Open the "Battery Widget" app
   - Tap the settings button (⚙️) in top right
   - Toggle options on/off as desired

## Redmi Phone Specific Setup

For Redmi phones (MIUI), you may need to:

1. **Allow Background Activity:**
   - Go to Settings → Apps → Battery Widget
   - Enable "Autostart"
   - Enable "Background activity"

2. **Disable Battery Optimization:**
   - Go to Settings → Battery & performance
   - Tap "Battery optimization"
   - Find "Battery Widget" and set to "Don't optimize"

3. **Enable Notifications:**
   - Go to Settings → Notifications
   - Find "Battery Widget" and enable all permissions

## Widget Display

The widget shows:
- 🔋 Battery icon (changes based on level)
- **XX%** - Large percentage text
- "Charging" status when plugged in
- Color changes:
  - 🟢 Green: Good battery level
  - 🟡 Orange: Charging
  - 🔴 Red: Low battery (≤20%)

## Troubleshooting

### Widget Not Updating?
- Restart the phone
- Remove and re-add the widget
- Check battery optimization settings

### Can't Find Widget?
- Make sure app is installed
- Try restarting the phone
- Look in "All Widgets" list

### For MIUI/Redmi Issues:
- Go to Settings → Apps → Battery Widget
- Enable all permissions
- Set to "No restrictions" under Battery

## Development

Built with Flutter 3.29.3 using:
- `battery_plus` for battery monitoring
- `home_widget` for widget functionality
- `shared_preferences` for settings

## Building from Source

```bash
# Ensure FVM is installed and Flutter 3.29.3 is active
fvm use 3.29.3
fvm flutter pub get
fvm flutter build apk --release
```

---

**Note**: This widget is designed to be simple and non-interactive to prevent accidental taps. The main app provides configuration options while the widget itself is read-only.
