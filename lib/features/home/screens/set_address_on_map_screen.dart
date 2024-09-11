import 'package:alerta_criminal/features/home/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetAddressOnMapScreen extends StatefulWidget {
  SetAddressOnMapScreen({
    super.key,
    required this.markers,
    required this.userLocation,
    required this.onSetLocation,
  });

  final Set<Marker> markers;
  LatLng userLocation;
  final void Function(LatLng location) onSetLocation;

  @override
  State<StatefulWidget> createState() {
    return _SetAddressOnMapScreenState();
  }
}

class _SetAddressOnMapScreenState extends State<SetAddressOnMapScreen> {
  void setLocation(LatLng location) {
    widget.userLocation = location;
    widget.onSetLocation(location);
  }
  void saveAndBackWithUserLocation() => Navigator.of(context).pop(widget.userLocation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Address'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: saveAndBackWithUserLocation,
          )
        ],
      ),
      body: MapWidget(
        markers: widget.markers,
        userLocation: widget.userLocation,
        isSelecting: true,
        onSelectNewLocation: setLocation,

      ),
    );
  }
}
