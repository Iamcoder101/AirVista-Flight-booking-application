import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight.dart';
import 'package:intl/intl.dart';

class FlightService {
  static Future<List<Flight>?> searchFlights(
    String origin,
    String destination,
    DateTime date,
    int adults,
  ) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final apiUrl = Uri.parse(
      'http://localhost:8080/api/flights/search?origin=$origin&destination=$destination&date=$formattedDate&adults=$adults',
    );

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).map((e) => Flight.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
