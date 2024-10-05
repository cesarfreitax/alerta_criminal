import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  Address({
    required this.name,
    required this.location,
});

  final String name;
  final LatLng location;
}