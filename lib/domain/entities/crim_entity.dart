import 'package:alerta_criminal/data/models/crim_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CrimEntity {
  CrimEntity({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
  });

  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final LatLng location;
}

extension CrimEntityExtension on CrimModel {
  CrimEntity toEntity() {
    return CrimEntity(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      location: location
    );
  }
}
