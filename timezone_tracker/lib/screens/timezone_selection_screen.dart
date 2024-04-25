import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class TimezoneSelectionScreen extends StatefulWidget {
  @override
  _TimezoneSelectionScreenState createState() =>
      _TimezoneSelectionScreenState();
}

class _TimezoneSelectionScreenState extends State<TimezoneSelectionScreen> {
  List<String> allTimezones = [];
  List<String> favoriteTimezones = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    allTimezones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteTimezones = prefs.getStringList('favoriteTimezones') ?? [];
      print('Loaded favorites: $favoriteTimezones'); // Debug log
    });
  }

  void _toggleFavorite(String timezone) async {
    setState(() {
      if (favoriteTimezones.contains(timezone)) {
        favoriteTimezones.remove(timezone);
      } else {
        favoriteTimezones.add(timezone);
      }
      prefs
          .setStringList('favoriteTimezones', favoriteTimezones)
          .then((bool success) {
        print('Updated favorites: $favoriteTimezones'); // Debug log
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Favorite Timezones'),
      ),
      body: ListView.builder(
        itemCount: allTimezones.length,
        itemBuilder: (context, index) {
          String timezone = allTimezones[index];
          bool isFavorite = favoriteTimezones.contains(timezone);
          return ListTile(
            title: Text(timezone),
            trailing: Icon(
              isFavorite ? Icons.check_box : Icons.check_box_outline_blank,
              color: isFavorite ? Colors.blue : null,
            ),
            onTap: () => _toggleFavorite(timezone),
          );
        },
      ),
    );
  }
}
