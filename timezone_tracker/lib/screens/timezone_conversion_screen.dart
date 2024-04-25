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
  late List<String> _timezones;
  String? _fromTimezone;
  String? _toTimezone;

  @override
  void initState() {
    super.initState();
    _initializeTimezones();
  }

  void _initializeTimezones() {
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
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return _timezones.where((String option) {
                return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
              });
            },
            onSelected: (String selectedTimezone) {
              setState(() {
                _fromTimezone = selectedTimezone;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  labelText: 'From Timezone',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return _timezones.where((String option) {
                return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
              });
            },
            onSelected: (String selectedTimezone) {
              setState(() {
                _toTimezone = selectedTimezone;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  labelText: 'To Timezone',
                  border: OutlineInputBorder(),
                ),
              );
            },
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
}
