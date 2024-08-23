import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/features/home/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/providers/crims_notifier.dart';
import '../../../core/utils/location_util.dart';
import '../../../data/models/crim_model.dart';
import '../widgets/add_new_crim_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> futureCrims;
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    futureCrims = ref.read(crimsProvider.notifier).getCrims();
    setLocation();
  }

  void setLocation() async {
    final locationData = await getLocation();

    if (locationData == null) {
      return;
    }

    setState(() {
      userLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  Set<Marker> getMarkers(List<CrimModel> crims) {
    return crims
        .map(
          (crim) => Marker(
            markerId: MarkerId(crim.id),
            position: LatLng(crim.lat, crim.lng),
          ),
        )
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final List<CrimModel> crims = ref.watch(crimsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(getStrings(context).map),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: DependencyInjection.authService.signOut,
          )
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: futureCrims,
            builder: (context, snapshot) {
              return userLocation != null
                  ? MapWidget(
                markers: getMarkers(crims),
                userLocation: userLocation!,
                isSelecting: false,
              )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
          Positioned(
              child: Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                AddNewCrimBottomSheet().show(context,
                    DependencyInjection.crimUseCase.add, userLocation!);
              },
              child: const Icon(Icons.add),
            ),
          ))
        ],
      ),
    );
  }
}
