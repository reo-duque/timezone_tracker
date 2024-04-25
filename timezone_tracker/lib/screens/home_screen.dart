import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timezone_conversion_screen.dart';
import 'timezone_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _trackedTimezones = [];
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timezone Tracker'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Convert Timezone':
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TimezoneConversionScreen(),
                  ));
                  break;
                case 'Add Timezones':
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => TimezoneSelectionScreen(),
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
      body: ListView.builder(
        itemCount: _trackedTimezones.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_trackedTimezones[index] +
                " - " +
                DateFormat('HH:mm:ss', 'en_US').format(DateTime.now())),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removeTimeZone(index);
              },
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
