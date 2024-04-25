import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneConversionScreen extends StatefulWidget {
  @override
  _TimezoneConversionScreenState createState() =>
      _TimezoneConversionScreenState();
}

class _TimezoneConversionScreenState extends State<TimezoneConversionScreen> {
  List<String> allTimezones = [];
  String? _fromTimezone;
  String? _toTimezone;
  String? _fromDateTime;
  String? _toDateTime;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    allTimezones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    if (allTimezones.isNotEmpty) {
      _fromTimezone = allTimezones.first;
      _toTimezone = allTimezones.first;
      _updateDateTimes();
    }
  }

  void _updateDateTimes() {
    final now = DateTime.now();
    if (_fromTimezone != null) {
      final fromTZ = tz.getLocation(_fromTimezone!);
      _fromDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(tz.TZDateTime.from(now, fromTZ));
    }
    if (_toTimezone != null) {
      final toTZ = tz.getLocation(_toTimezone!);
      _toDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(tz.TZDateTime.from(now, toTZ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timezone Converter'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'From Timezone',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              controller: TextEditingController(text: _fromTimezone),
              onTap: () => _showSearch(context, true),
            ),
            const SizedBox(height: 10),
            if (_fromDateTime != null)
              Text('Current date and time: $_fromDateTime'),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'To Timezone',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              controller: TextEditingController(text: _toTimezone),
              onTap: () => _showSearch(context, false),
            ),
            const SizedBox(height: 10),
            if (_toDateTime != null)
              Text('Current date and time: $_toDateTime'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateDateTimes,
              child: const Text('Convert Timezones'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearch(BuildContext context, bool isFrom) {
    showSearch(
      context: context,
      delegate: TimeZoneSearch(
        allTimezones,
        isFrom ? _updateFromSearch : _updateToSearch,
      ),
    );
  }

  void _updateFromSearch(String timezone) {
    Navigator.of(context).pop(); // Close the search
    setState(() {
      _fromTimezone = timezone;
      _updateDateTimes();
    });
  }

  void _updateToSearch(String timezone) {
    Navigator.of(context).pop(); // Close the search
    setState(() {
      _toTimezone = timezone;
      _updateDateTimes();
    });
  }
}

class TimeZoneSearch extends SearchDelegate<String> {
  final List<String> timezones;
  final Function(String) onSelected;

  TimeZoneSearch(this.timezones, this.onSelected);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = timezones.where((timezone) {
      return timezone.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            onSelected(suggestions[index]);
            close(context, suggestions[index]);
          },
        );
      },
    );
  }
}
