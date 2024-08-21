import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CrimModel {
  CrimModel(
      {required this.title,
      required this.description,
      required this.location,
      id,
      imageUrl})
      : id = id ?? uuid.v4(),
        imageUrl = imageUrl ?? "";

  final String id;
  String imageUrl;
  final String title;
  final String description;
  final LatLng location;
}
