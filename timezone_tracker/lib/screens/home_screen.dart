import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../animation/animated_clock.dart';
import 'timezone_conversion_screen.dart' as ConversionScreen;
import 'timezone_selection_screen.dart' as SelectionScreen;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _trackedTimezones = [];
  SharedPreferences? _prefs;
  bool _showClock = true; // State to control display mode

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _loadTimezones();
  }

  void _loadTimezones() async {
    _prefs = await SharedPreferences.getInstance();
    _updateTrackedTimezones();
  }

  void _updateTrackedTimezones() {
    setState(() {
      _trackedTimezones = _prefs?.getStringList('favoriteTimezones') ?? [];
    });
  }

  void _toggleClockDisplay() {
    setState(() {
      _showClock = !_showClock; // Toggle between true and false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timezone Tracker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_showClock ? Icons.access_time : Icons.list),
            onPressed: _toggleClockDisplay,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Convert Timezone':
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ConversionScreen.TimezoneConversionScreen(),
                  ));
                  break;
                case 'Add Timezones':
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) =>
                            SelectionScreen.TimezoneSelectionScreen(),
                      ))
                      .then(
                          (_) => _updateTrackedTimezones()); // Update on return
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Convert Timezone', 'Add Timezones'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.5,
        ),
        itemCount: _trackedTimezones.length,
        itemBuilder: (context, index) {
          String timezone = _trackedTimezones[index];
          tz.Location location = tz.getLocation(timezone);
          tz.TZDateTime now = tz.TZDateTime.now(location);
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          timezone,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTimeZone(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _showClock
                      ? AnimatedClock(timezone: timezone)
                      : Text(
                          DateFormat('yyyy-MM-dd – HH:mm:ss').format(now),
                          style: const TextStyle(fontSize: 16),
                        ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _removeTimeZone(int index) async {
    _trackedTimezones.removeAt(index);
    await _prefs?.setStringList('favoriteTimezones', _trackedTimezones);
    _updateTrackedTimezones(); // Refresh the list
  }
}
