import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:food_group_app/src/config/globals.dart';
import 'package:food_group_app/src/models/google/place.dart';
import 'package:food_group_app/src/models/google/suggestion.dart';
import 'package:food_group_app/src/utils/logger.dart';
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

  /// Fetch suggestions given a string location (mocked data).
  static Future<List<Suggestion>> fetchSuggestionsMock(
    String input,
    double latitude,
    double longitude,
    String token,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    log.i('Returning mock suggestions');
    return [
      Suggestion(
        placeId: '1111',
        description: 'Jimmy Johns Lake Cook Road',
        name: 'Jimmy Johns',
      ),
      Suggestion(
        placeId: '222',
        description: 'Jimmy Johns East View Road',
        name: 'Jimmy Johns',
      ),
      Suggestion(
        placeId: '333',
        description: 'Jimmy Johns West View Road',
        name: 'Jimmy Johns',
      ),
    ];
  }

  /// Fetch suggestions given a string location
  static Future<List<Suggestion>> fetchSuggestions(
    String input,
    double latitude,
    double longitude,
    String token,
  ) async {
    var query = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(input)}'
        '&location=$latitude%2C$longitude'
        '&types=restaurant'
        '&key=${dotenv.env[AppConfig.envGoogleMapsApiKey]}'
        '&sessiontoken=$token';
    log.i("Invoking google place autocomplete API");
    var response = await http.get(Uri.parse(query));
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      if (json['status'] == 'OK') {
        log.i(json['predictions']);
        return json['predictions']
            .map<Suggestion>(
              (p) => Suggestion(
                placeId: p['place_id'] as String,
                description: p['description'] as String,
                name: p['structured_formatting']['main_text'] as String,
              ),
            )
            .toList() as List<Suggestion>;
      }
      if (json['status'] == 'ZERO_RESULTS') {
        return [];
      }
      log.e(json['error_message']);
      throw Exception(json['error_message']);
    } else {
      log.e('Failed to fetch suggestion');
      throw Exception('Failed to fetch suggestion');
    }
  }

  static Future<Place> getPlaceDetailsFromId(
    String placeId,
    String token,
  ) async {
    var query = 'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&key=${dotenv.env[AppConfig.envGoogleMapsApiKey]}'
        '&fields=formatted_address,name,photo'
        '&sessiontoken=$token';
    log.i("Invoking google place details API");
    var response = await http.get(Uri.parse(query));
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      if (json['status'] == 'OK') {
        log.i(json['result']);
        return Place(
          address: json['result']['formatted_address'] as String,
          name: json['result']['name'] as String,
          photoReference:
              json['result']['photos'][0]['photo_reference'] as String,
        );
      } else {
        log.e('Failed to fetch place details');
        throw Exception('Failed to fetch details');
      }
    } else {
      log.e('Failed to fetch place details');
      throw Exception('Failed to fetch details');
    }
  }

  static CachedNetworkImage getPhotoFromReference(
      String photoReference, int maxWidth) {
    var query = 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=${dotenv.env[AppConfig.envGoogleMapsApiKey]}';
    return CachedNetworkImage(
      imageUrl: query,
      fit: BoxFit.fill,
      placeholder: (context, string) =>
          const Center(child: CircularProgressIndicator()),
    );
  }
}
