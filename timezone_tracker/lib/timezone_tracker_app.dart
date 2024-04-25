import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class TimezoneTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timezone Tracker',
      home: HomeScreen(),
    );
  }
}
