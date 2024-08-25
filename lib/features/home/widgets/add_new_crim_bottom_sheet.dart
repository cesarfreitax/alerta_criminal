import 'dart:io';

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/date_util.dart';
import 'package:alerta_criminal/core/utils/location_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/features/home/screens/set_address_on_map_screen.dart';
import 'package:alerta_criminal/features/home/widgets/photo_preview_widget.dart';
import 'package:alerta_criminal/theme/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddNewCrimBottomSheet {
  Future<dynamic> show(
    BuildContext ctx,
    void Function(CrimeModel crim) addNewCrim,
    LatLng location,
  ) async {
    addNewCrim = addNewCrim;
    return showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return Container(
          height: 600,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(ctx).colorScheme.secondaryContainer,
            Theme.of(ctx).colorScheme.surface,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: _AddNewCrimBottomSheet(
            addNewCrim: addNewCrim,
            location: location,
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}

class _AddNewCrimBottomSheet extends StatefulWidget {
  _AddNewCrimBottomSheet({
    required this.addNewCrim,
    required this.location,
  });

  final void Function(CrimeModel crim) addNewCrim;
  LatLng location;

  @override
  State<_AddNewCrimBottomSheet> createState() {
    return _AddNewCrimBottomSheetState();
  }
}

class _AddNewCrimBottomSheetState extends State<_AddNewCrimBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  late LatLng userLocation;
  final currentDate = DateTime.now();
  late TimeOfDay currentTime;

  File? image;

  void submit() {
    final formInvalid = !formKey.currentState!.validate();
    if (formInvalid) {
      return;
    }

    addNewCrim();
    Navigator.pop(context);
  }

  void addNewCrim() async {
    final crim = CrimeModel(
      title: titleController.text,
      description: descriptionController.text,
      lat: userLocation.latitude,
      lng: userLocation.longitude,
      userId: getCurrentUser()!.uid,
      date: Timestamp.fromDate(DateTime.now())
    );

    if (image != null) {
      final imageUrl = await DependencyInjection.userDataUseCase
          .saveCrimImage(image!, getCurrentUser()!.uid);
      crim.imageUrl = imageUrl;
    }

    widget.addNewCrim(crim);
  }

  @override
  void initState() {
    super.initState();
    setLocation(widget.location);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
  }

  void setLocation(LatLng location) {
    setState(() {
      userLocation = location;
    });
  }

  void setOnMap() async {
    final location = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => SetAddressOnMapScreen(
          markers: {
            Marker(markerId: const MarkerId("m1"), position: userLocation)
          },
          userLocation: widget.location,
        ),
      ),
    );

    if (location == null) {
      return;
    }
    setLocation(location);
  }

  void setDatePicker() async {
    final pickedDate = await openDatePicker(context);

    if (pickedDate == null) {
      return;
    }

    setState(() {
      dateController.text = formatDate(pickedDate);
    });
  }

  void setTimePicker() async {
    final pickedTime = await openTimePicker(context);

    if (pickedTime == null) {
      return;
    }

    setState(() {
      timeController.text = formatTime(pickedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget verticalSpacing = const SizedBox(
      height: 16,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PhotoPreviewWidget(setImage: (img) => image = img),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length < 4) {
                        return getStrings(context).addCrimTitleError;
                      }
                      return null;
                    },
                    decoration:
                        InputDecoration(labelText: getStrings(context).title),
                  ),
                  verticalSpacing,
                  TextFormField(
                    maxLines: 4,
                    controller: descriptionController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        labelText: getStrings(context).description,
                        alignLabelWithHint: true),
                  ),
                ],
              ),
            ),
            verticalSpacing,
            SizedBox(
              width: double.infinity,
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  getStrings(context).crimeLocale,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2))),
                  child: Image.network(
                    getLocationImagePreview(
                      userLocation.latitude,
                      userLocation.longitude,
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    child: IconButton(
                      onPressed: setOnMap,
                      icon: Icon(
                        Icons.map_rounded,
                        color: CustomColors().blue,
                      ),
                    ),
                  ),
                )
              ],
            ),
            verticalSpacing,
            Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  onPressed: submit,
                  label: Text(getStrings(context).send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
