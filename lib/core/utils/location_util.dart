import 'dart:convert';

import 'package:alerta_criminal/core/utils/env.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

final mapsApiKey = Env.mapsApiKey;
const mapsApi = 'https://maps.googleapis.com/maps/api';

Future<LocationData?> getLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  locationData = await location.getLocation();
  return locationData;
}

Future<String> getAddress(double lat, double lng) async {
  final url = Uri.parse(
      "$mapsApi/geocode/json?latlng=$lat,$lng&key=$mapsApiKey");
  final response = await http.get(url);
  final resData = jsonDecode(response.body);
  final address = resData["results"][0]["formatted_address"];

  return address;
}

String getLocationImagePreview(double lat, double lng,
    [int? zoom, String? size, String? type, String? markerColor]) {
  return "$mapsApi/staticmap?center=$lat,$lng&zoom=${zoom ?? 16}&size=${size ?? "600x300"}&maptype=${type ?? "roadmap"}&markers=color:${markerColor ?? "red"}%7Clabel:S%7C$lat,$lng&key=$mapsApiKey";
}
