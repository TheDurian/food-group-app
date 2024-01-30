import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:food_group_app/src/config/globals.dart';
import 'package:food_group_app/src/models/google/suggestion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:location/location.dart';

class GooglePlaceService {
  /// Retrieves the current location of the device.
  ///
  /// A popup will display if the location service
  /// is not enabled / allowed. Null will be returned
  /// if permission is not granted.
  static Future<LocationData?> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  /// Fetch suggestions given a string location
  static Future<List<Suggestion>> fetchSuggestions(
    String input,
    double latitude,
    double longitude,
    String token,
  ) async {
    var query = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&location=$latitude%2C$longitude'
        '&types=restaurant'
        '&key=${dotenv.env[AppConfig.envGoogleMapsApiKey]}'
        '&sessiontoken=$token';
    var response = await http.get(Uri.parse(query));
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      if (json['status'] == 'OK') {
        return json['predictions']
            .map<Suggestion>(
              (p) => Suggestion(
                p['place_id'] as String,
                p['description'] as String,
                p['structured_formatting']['main_text'] as String,
              ),
            )
            .toList() as List<Suggestion>;
      }
      if (json['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(json['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  // Future<Place> getPlaceDetailFromId(String placeId) async {
  //   final request =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
  //   final response = await client.get(request);

  //   if (response.statusCode == 200) {
  //     final result = json.decode(response.body);
  //     if (result['status'] == 'OK') {
  //       final components =
  //           result['result']['address_components'] as List<dynamic>;
  //       // build result
  //       final place = Place();
  //       components.forEach((c) {
  //         final List type = c['types'];
  //         if (type.contains('street_number')) {
  //           place.streetNumber = c['long_name'];
  //         }
  //         if (type.contains('route')) {
  //           place.street = c['long_name'];
  //         }
  //         if (type.contains('locality')) {
  //           place.city = c['long_name'];
  //         }
  //         if (type.contains('postal_code')) {
  //           place.zipCode = c['long_name'];
  //         }
  //       });
  //       return place;
  //     }
  //     throw Exception(result['error_message']);
  //   } else {
  //     throw Exception('Failed to fetch suggestion');
  //   }
  // }
}
