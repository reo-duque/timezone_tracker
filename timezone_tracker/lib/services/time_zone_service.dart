import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeZoneService {
  //Base URL for the time zone API
  final String baseUrl = "http://worldtimeapi.org/api/timezone/";

  //Function to get the time zone data
  Future<List<String>> fetchTimeZones() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        //If the server returns a 200 OK response, parse the JSON data
        List<dynamic> data = json.decode(response.body);
        return data.map((tz) => tz.toString()).toList();
      } else {
        //If the server returns an error response, throw an exception
        throw Exception('Failed to load time zones');
      }
    } catch (e) {
      //If an error occurs, throw an exception
      throw Exception('Failed to load time zones: $e');
    }
  }
}
