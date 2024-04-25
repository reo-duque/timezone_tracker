import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart';

class TimezoneConversionScreen extends StatefulWidget {
  @override
  _TimezoneConversionScreenState createState() =>
      _TimezoneConversionScreenState();
}

class _TimezoneConversionScreenState extends State<TimezoneConversionScreen> {
  List<String> _timezones = [];
  String? _fromTimezone;
  String? _toTimezone;

  @override
  void initState() {
    super.initState();
    _timezones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    if (_timezones.isNotEmpty) {
      _fromTimezone = _timezones.first;
      _toTimezone = _timezones.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timezone Converter'),
      ),
      body: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _fromTimezone,
            decoration: InputDecoration(
              labelText: 'From Timezone',
              border: OutlineInputBorder(),
            ),
            onChanged: (newValue) {
              setState(() {
                _fromTimezone = newValue;
              });
            },
            items: _timezones.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _toTimezone,
            decoration: InputDecoration(
              labelText: 'To Timezone',
              border: OutlineInputBorder(),
            ),
            onChanged: (newValue) {
              setState(() {
                _toTimezone = newValue;
              });
            },
            items: _timezones.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _convertTime(),
            child: Text('Convert Time'),
          ),
          SizedBox(height: 20),
          if (_fromTimezone != null && _toTimezone != null)
            Text(
                'Time in $_fromTimezone: ${_formatTime(_fromTimezone!)}\nTime in $_toTimezone: ${_formatTime(_toTimezone!)}'),
        ],
      ),
    );
  }

  String _formatTime(String timezone) {
    final location = tz.getLocation(timezone);
    final now = tz.TZDateTime.now(location);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  void _convertTime() {
    setState(() {
      // This function simply triggers a rebuild to update the time display
    });
  }
}
