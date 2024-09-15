import 'package:alerta_criminal/domain/repositories/location_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/place_suggestions_model.dart';

class LocationUseCase {
  final LocationRepository repository;

  LocationUseCase(this.repository);

  Future<String> getAddressByLatLng(double lat, double lng) async => repository.getAddressByLatLng(lat, lng);

  Future<LatLng> getLatLngByAddress(String address) async => repository.getLatLngByAddress(address);

  Future<PlaceSuggestionsModel> getPlaceSuggestions(String enteredAddress, LatLng userLocation, int radiusAreaInMeters, String userLanguage) => repository.getPlaceSuggestions(enteredAddress, userLocation, radiusAreaInMeters, userLanguage);
}
