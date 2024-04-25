import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'timezone_tracker_app.dart';

void main() {
  tz.initializeTimeZones();
  runApp(TimezoneTrackerApp());
}
