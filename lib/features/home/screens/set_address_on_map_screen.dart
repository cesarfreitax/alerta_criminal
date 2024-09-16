import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/address.dart';
import 'package:alerta_criminal/features/home/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetAddressOnMapScreen extends StatefulWidget {
  SetAddressOnMapScreen({
    super.key,
    required this.markers,
    required this.userLocation,
  });

  final Set<Marker> markers;
  LatLng userLocation;
  @override
  State<StatefulWidget> createState() {
    return _SetAddressOnMapScreenState();
  }
}

class _SetAddressOnMapScreenState extends State<SetAddressOnMapScreen> {
  Address? address;

  void saveAndBackWithUserLocation() => Navigator.of(context).pop(address);

  void onSelectNewLocation(String newAddress , LatLng newLocation) {
    address = Address(name: newAddress, location: newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: screenTitle(context),
        actions: [
          saveLocationBtn()
        ],
      ),
      body: map(),
    );
  }

  Text screenTitle(BuildContext context) => Text(getStrings(context).setAddress);

  MapWidget map() {
    return MapWidget(
      markers: widget.markers,
      userLocation: widget.userLocation,
      isSelecting: true,
      onSelectNewLocation: onSelectNewLocation,
    );
  }

  IconButton saveLocationBtn() {
    return IconButton(
          icon: const Icon(Icons.check),
          onPressed: saveAndBackWithUserLocation,
        );
  }
}
