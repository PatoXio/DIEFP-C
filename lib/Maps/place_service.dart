import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

class Place {
  String streetNumber;
  String street;
  String region;
  String city;
  String zipCode;
  String provincia;
  String country;
  double lat;
  double lng;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.region,
    this.zipCode,
    this.lat,
    this.lng,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, Provincia: $provincia, Region: $region, Country: $country, zipCode: $zipCode, lat: $lat, lng: $lng)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyDgxiJ5v8gB1Qil9NbS1aVLOCaJtwFKlmA';
  static final String iosKey = 'AIzaSyDgxiJ5v8gB1Qil9NbS1aVLOCaJtwFKlmA';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=es&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        //'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken';

    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        print(components.toString());
        final location = result['result']['geometry'] as Map<String, dynamic>;
        print(location.toString());
        // build result
        final place = Place();

        location.forEach((key, value) {
          if (key.compareTo('location') == 0) {
            Map<String, dynamic> valores = value;
            valores.forEach((key, value) {
              if (key.compareTo('lat') == 0) {
                place.lat = value;
              } else if (key.compareTo('lng') == 0) {
                place.lng = value;
              }
            });
          }
        });
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('country')) {
            place.country = c['long_name'];
          }
          if (type.contains('administrative_area_level_2')) {
            place.provincia = c['long_name'];
          }
          if (type.contains('administrative_area_level_1')) {
            place.region = c['long_name'];
          }
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
