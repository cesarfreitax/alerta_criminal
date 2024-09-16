import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../data/models/place_suggestions_model.dart';

abstract class LocationRepository {
  Future<LocationData?> getLocation();

  Future<PlaceSuggestionsModel> getPlaceSuggestions(String enteredAddress, LatLng userLocation, int radiusAreaInMeters, String userLanguage);

  Future<LatLng> getLatLngByAddress(String address);

  Future<String> getAddressByLatLng(double lat, double lng);
}
