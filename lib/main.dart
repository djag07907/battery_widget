import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const BatteryWidgetApp());
}

class BatteryWidgetApp extends StatelessWidget {
  const BatteryWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Widget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20),
        ),
      ),
      home: const BatteryWidgetHome(),
    );
  }
}

class BatteryWidgetHome extends StatefulWidget {
  const BatteryWidgetHome({super.key});

  @override
  State<BatteryWidgetHome> createState() => _BatteryWidgetHomeState();
}

class _BatteryWidgetHomeState extends State<BatteryWidgetHome> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  Timer? _timer;
  bool _showPercentage = true;
  bool _showChargingStatus = true;
  String _widgetTitle = 'Battery';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _updateBattery();
    _startTimer();
    _initializeWidgetChannel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateBattery();
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showPercentage = prefs.getBool('show_percentage') ?? true;
      _showChargingStatus = prefs.getBool('show_charging_status') ?? true;
      _widgetTitle = prefs.getString('widget_title') ?? 'Battery';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_percentage', _showPercentage);
    await prefs.setBool('show_charging_status', _showChargingStatus);
    await prefs.setString('widget_title', _widgetTitle);
  }

  Future<void> _updateBattery() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;
      
      setState(() {
        _batteryLevel = batteryLevel;
        _batteryState = batteryState;
      });
      
      // Update native widget via platform channel
      await _updateNativeWidget();
    } catch (e) {
      debugPrint('Error updating battery: $e');
    }
  }

  static const platform = MethodChannel('com.example.battery_widget/widget');

  Future<void> _initializeWidgetChannel() async {
    // Initialize platform channel for widget communication
    try {
      await platform.invokeMethod('initializeWidget');
    } catch (e) {
      debugPrint('Error initializing widget channel: $e');
    }
  }

  Future<void> _updateNativeWidget() async {
    try {
      await platform.invokeMethod('updateWidget', {
        'batteryLevel': _batteryLevel,
        'isCharging': _batteryState == BatteryState.charging || _batteryState == BatteryState.full,
        'widgetTitle': _widgetTitle,
      });
    } catch (e) {
      debugPrint('Error updating native widget: $e');
    }
  }


  String get _batteryStateText {
    switch (_batteryState) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.unknown:
      default:
        return 'Unknown';
    }
  }

  Color get _batteryColor {
    if (_batteryState == BatteryState.charging || _batteryState == BatteryState.full) {
      return const Color(0xFF388E3C);
    } else if (_batteryLevel <= 20) {
      return const Color(0xFFD32F2F);
    } else {
      return const Color(0xFF2E7D32);
    }
  }

  IconData get _batteryIcon {
    if (_batteryState == BatteryState.charging) {
      return Icons.battery_charging_full;
    } else if (_batteryLevel >= 90) {
      return Icons.battery_full;
    } else if (_batteryLevel >= 70) {
      return Icons.battery_5_bar;
    } else if (_batteryLevel >= 50) {
      return Icons.battery_4_bar;
    } else if (_batteryLevel >= 30) {
      return Icons.battery_3_bar;
    } else if (_batteryLevel >= 15) {
      return Icons.battery_2_bar;
    } else {
      return Icons.battery_alert;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Widget for Grandma'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _batteryIcon,
                      size: 80,
                      color: _batteryColor,
                    ),
                    const SizedBox(height: 16),
                    if (_showPercentage)
                      Text(
                        '$_batteryLevel%',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: _batteryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (_showChargingStatus)
                      Text(
                        _batteryStateText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _batteryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, size: 40, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'Widget Instructions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Long press on the home screen\n'
                      '2. Tap "Widgets"\n'
                      '3. Find "Battery Widget"\n'
                      '4. Drag it to your home screen',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _updateBattery,
        label: const Text('Refresh'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Widget Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Show Percentage'),
              value: _showPercentage,
              onChanged: (value) {
                setState(() {
                  _showPercentage = value;
                });
                _saveSettings();
                _updateNativeWidget();
              },
            ),
            SwitchListTile(
              title: const Text('Show Charging Status'),
              value: _showChargingStatus,
              onChanged: (value) {
                setState(() {
                  _showChargingStatus = value;
                });
                _saveSettings();
                _updateNativeWidget();
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Widget Title',
                hintText: 'Enter widget title',
              ),
              controller: TextEditingController(text: _widgetTitle),
              onChanged: (value) {
                _widgetTitle = value;
                _saveSettings();
                _updateNativeWidget();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}