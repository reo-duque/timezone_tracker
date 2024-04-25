import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveTimeZone(String timeZone) async {
    List<String> timeZoneList = getTimeZones();
    if (!timeZoneList.contains(timeZone)) {
      timeZoneList.add(timeZone);
      return await (_prefs?.setStringList('favoriteTimezones', timeZoneList) ??
          Future.value(false));
    }
    return Future.value(false);
  }

  static List<String> getTimeZones() {
    return _prefs?.getStringList('favoriteTimezones') ?? [];
  }

  static Future<bool> deleteTimeZone(String timeZone) async {
    List<String> timeZoneList = getTimeZones();
    if (timeZoneList.contains(timeZone)) {
      timeZoneList.remove(timeZone);
      return await (_prefs?.setStringList('favoriteTimezones', timeZoneList) ??
          Future.value(false));
    }
    return Future.value(false);
  }
}
