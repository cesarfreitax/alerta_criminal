import 'dart:convert';

import 'package:alerta_criminal/data/models/place_suggestions_model.dart';
import 'package:alerta_criminal/domain/repositories/location_repository.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/env.dart';

class LocationRepositoryImpl extends LocationRepository {
  final mapsApiKey = Env.mapsApiKey;
  final mapsApi = 'https://maps.googleapis.com/maps/api';

  Uri getLatLngByAddressEndpoint(
    String address,
    String mapsApiKey,
  ) =>
      Uri.parse("$mapsApi/geocode/json?address=$address&key=$mapsApiKey");

  Uri getAddressByLatLngEndpoint(
    double lat,
    double lng,
  ) =>
      Uri.parse("$mapsApi/geocode/json?latlng=$lat,$lng&key=$mapsApiKey");

  Uri getPlaceSuggestionsEndpoint(
    int radiusAreaInMeters,
    String address,
    double lat,
    double lng,
    String userLanguage,
  ) =>
      Uri.parse("$mapsApi/place/autocomplete/json?input=${Uri.encodeComponent(address)}&location=$lat,$lng&radius=$radiusAreaInMeters&language=$userLanguage&key=$mapsApiKey");

  @override
  Future<String> getAddressByLatLng(double lat, double lng) async {
    final url = getAddressByLatLngEndpoint(lat, lng);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);
      final address = resData["results"][0]["formatted_address"];
      return address;
    } else {
      throw Exception('Failed to get address');
    }
  }

  @override
  Future<LatLng> getLatLngByAddress(String address) async {
    final url = getLatLngByAddressEndpoint(address, mapsApiKey);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);
      final location = resData["results"][0]["geometry"]["location"];
      return LatLng(location["lat"], location["lng"]);
    } else {
      throw Exception('Failed to get location');
    }
  }

  @override
  Future<PlaceSuggestionsModel> getPlaceSuggestions(
      String enteredAddress, LatLng userLocation, int radiusAreaInMeters, String userLanguage) async {
    final response = await http.get(getPlaceSuggestionsEndpoint(radiusAreaInMeters, enteredAddress, userLocation.latitude, userLocation.longitude, userLanguage));
    final resData = jsonDecode(response.body);
    final predictions = PlaceSuggestionsModel.fromJson(resData);
    return predictions;
  }
}
