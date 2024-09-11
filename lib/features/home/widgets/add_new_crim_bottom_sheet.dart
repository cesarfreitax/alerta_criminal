import 'dart:io';

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/location_notifier.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/date_util.dart';
import 'package:alerta_criminal/core/utils/location_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/features/home/screens/set_address_on_map_screen.dart';
import 'package:alerta_criminal/features/home/widgets/photo_preview_widget.dart';
import 'package:alerta_criminal/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddNewCrimBottomSheet {
  Future<dynamic> show(
    BuildContext ctx,
    void Function(CrimeModel crim) addNewCrim,
    Future<void> Function() resetCurrentLocation,
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
            resetCurrentLocation: resetCurrentLocation,
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}

class _AddNewCrimBottomSheet extends ConsumerStatefulWidget {
  const _AddNewCrimBottomSheet({
    required this.addNewCrim,
    required this.resetCurrentLocation,
  });

  final void Function(CrimeModel crim) addNewCrim;
  final Future<void> Function() resetCurrentLocation;

  @override
  ConsumerState<_AddNewCrimBottomSheet> createState() {
    return _AddNewCrimBottomSheetState();
  }
}

class _AddNewCrimBottomSheetState
    extends ConsumerState<_AddNewCrimBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  late LatLng? userLocation;
  late DateTime currentDate;
  late TimeOfDay currentTime;
  var locationManuallyChanged = false;

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
    final pickedDate = DateTime(currentDate.year, currentDate.month,
        currentDate.day, currentTime.hour, currentTime.minute);

    final crim = CrimeModel(
        title: titleController.text,
        description: descriptionController.text,
        lat: userLocation!.latitude,
        lng: userLocation!.longitude,
        userId: getCurrentUser()!.uid,
        date: pickedDate);

    if (image != null) {
      final imageUrl = await DependencyInjection.userDataUseCase
          .saveCrimImage(image!, crim.id);
      crim.imageUrl = imageUrl;
    }

    widget.addNewCrim(crim);
  }

  @override
  void initState() {
    super.initState();
    setDateAndTime();
  }

  void setDateAndTime() {
    currentDate = DateTime.now();
    currentTime = TimeOfDay(hour: currentDate.hour, minute: currentDate.minute);
    dateController.text = formatDate(currentDate);
    timeController.text = formatTime(currentTime);
  }

  void resetUserLocation() =>
      ref.read(locationProvider.notifier).fetchLocation();

  @override
  void dispose() async {
    if (locationManuallyChanged) {
      await widget.resetCurrentLocation();
    }
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void setLocation(LatLng location) {
    locationManuallyChanged = true;
    ref.read(locationProvider.notifier).setLocation(location);
  }

  void setOnMap() async {
    final location = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => SetAddressOnMapScreen(
          markers: {
            Marker(markerId: const MarkerId("m1"), position: userLocation!)
          },
          userLocation: userLocation!,
          onSetLocation: setLocation,
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
      currentDate = pickedDate;
      dateController.text = formatDate(pickedDate);
    });
  }

  void setTimePicker() async {
    final pickedTime = await openTimePicker(context);

    if (pickedTime == null) {
      return;
    }

    setState(() {
      currentTime = pickedTime;
      timeController.text = formatTime(pickedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    userLocation = ref.watch(locationProvider);

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
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length < 10) {
                        return getStrings(context).addCrimDescriptionError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        labelText: getStrings(context).description,
                        alignLabelWithHint: true),
                  ),
                  verticalSpacing,
                  Row(
                    children: [
                      Expanded(
                        child: Flexible(
                          child: TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(
                              labelText: getStrings(context).date,
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: setDatePicker,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: timeController,
                          decoration: InputDecoration(
                            labelText: getStrings(context).hour,
                            prefixIcon: const Icon(Icons.watch_later_outlined),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                          readOnly: true,
                          onTap: setTimePicker,
                        ),
                      ),
                    ],
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
                      userLocation!.latitude,
                      userLocation!.longitude,
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
