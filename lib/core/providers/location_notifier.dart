import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/util/log_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationNotifier extends StateNotifier<LatLng?> {
  LocationNotifier() : super(null);

  Future<void> fetchLocation() async {
    try {
      final location = await DependencyInjection.locationUseCase.getLocation();
      state = location != null
          ? LatLng(location.latitude!, location.longitude!)
          : null;
    } catch (e) {
      final className = runtimeType.toString();
      printDebug('$className - Error Fetching Location: $e');
    }
  }

  void setLocation(LatLng location) => state = location;
}

final locationProvider = StateNotifierProvider<LocationNotifier, LatLng?>(
  (ref) => LocationNotifier(),
);
