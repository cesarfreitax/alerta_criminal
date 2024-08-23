import 'package:alerta_criminal/features/home/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetAddressOnMapScreen extends StatefulWidget {
  const SetAddressOnMapScreen({
    super.key,
    required this.markers,
    required this.userLocation,
  });

  final Set<Marker> markers;
  final LatLng userLocation;

  @override
  State<StatefulWidget> createState() {
    return _SetAddressOnMapScreenState();
  }
}

class _SetAddressOnMapScreenState extends State<SetAddressOnMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Address'),
      ),
      body: MapWidget(
        markers: widget.markers,
        userLocation: widget.userLocation,
        isSelecting: true,
      ),
    );
  }
}
