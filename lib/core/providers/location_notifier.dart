import 'package:alerta_criminal/core/utils/location_util.dart';
import 'package:alerta_criminal/core/utils/log_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationNotifier extends StateNotifier<LatLng?> {
  LocationNotifier() : super(null);

  Future<void> fetchLocation() async {
    try {
      final location = await getLocation();
      state = location != null ? LatLng(location.latitude!, location.longitude!) : null;
    } catch (e) {
      printDebug('Error fetching location: $e');
    }
  }

  void setLocation(LatLng location) {
    state = location;
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LatLng?>(
  (ref) => LocationNotifier(),
);
