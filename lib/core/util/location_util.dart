import 'package:alerta_criminal/core/util/env.dart';

final mapsApiKey = Env.mapsApiKey;
const mapsApi = 'https://maps.googleapis.com/maps/api';

String getLocationImagePreview(double lat, double lng,
    [int? zoom, String? size, String? type, String? markerColor]) {
  return "$mapsApi/staticmap?center=$lat,$lng&zoom=${zoom ?? 16}&size=${size ?? "600x300"}&maptype=${type ?? "roadmap"}&markers=color:${markerColor ?? "red"}%7Clabel:S%7C$lat,$lng&key=$mapsApiKey";
}
