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
  List<String> filteredTimezones = [];
  List<String> favoriteTimezones = [];
  late SharedPreferences prefs;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    allTimezones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    filteredTimezones = allTimezones;
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteTimezones = prefs.getStringList('favoriteTimezones') ?? [];
    });
  }

  void _toggleFavorite(String timezone) async {
    setState(() {
      if (favoriteTimezones.contains(timezone)) {
        favoriteTimezones.remove(timezone);
      } else {
        favoriteTimezones.add(timezone);
      }
      prefs.setStringList('favoriteTimezones', favoriteTimezones);
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      if (searchQuery.isNotEmpty) {
        filteredTimezones = allTimezones
            .where((timezone) =>
                timezone.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      } else {
        filteredTimezones = allTimezones;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Favorite Timezones'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search Timezones',
              hintText: 'Enter timezone name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: EdgeInsets.all(8),
            ),
            onChanged: _updateSearchQuery,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredTimezones.length,
        itemBuilder: (context, index) {
          String timezone = filteredTimezones[index];
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
