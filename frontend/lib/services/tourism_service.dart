import 'dart:convert';
import 'package:flutterapp/models/place.dart';
import 'package:http/http.dart' as http;

class TourismService {
  final String apiKey =
      '5ae2e3f221c38a28845f05b6fd7f25b9b6fbc2a4eb81127243e03cf5';
  final String baseUrl = 'https://api.opentripmap.com/0.1/en/places';

  Future<List<Place>> fetchTouristPlaces(String cityName) async {
    // Step 1: Geocode the city to get lat/lon
    final geoUrl =
        'https://api.opentripmap.com/0.1/en/places/geoname?name=$cityName&apikey=$apiKey';
    final geoResponse = await http.get(Uri.parse(geoUrl));

    if (geoResponse.statusCode != 200) {
      throw Exception('Failed to geocode location');
    }

    final geoData = json.decode(geoResponse.body);
    final double lat = geoData['lat'];
    final double lon = geoData['lon'];

    // Step 2: Fetch list of nearby places (radius = 1000 meters, adjust as needed)
    final placesUrl =
        '$baseUrl/radius?radius=1000&lon=$lon&lat=$lat&apikey=$apiKey';
    final placesResponse = await http.get(Uri.parse(placesUrl));

    if (placesResponse.statusCode != 200) {
      throw Exception('Failed to load nearby places');
    }

    final placesData = json.decode(placesResponse.body);
    final List features = placesData['features'];

    // Step 3: For each place, fetch detailed info via XID
    List<Place> places = [];
    for (var feature in features.take(9)) {
      // limit to 9 places for 3x3 grid
      final xid = feature['properties']['xid'];
      final detailUrl = '$baseUrl/xid/$xid?lang=en&apikey=$apiKey';
      final detailResponse = await http.get(Uri.parse(detailUrl));

      if (detailResponse.statusCode == 200) {
        final detailData = json.decode(detailResponse.body);
        places.add(Place.fromJson(detailData));
      }
    }

    return places;
  }
}
