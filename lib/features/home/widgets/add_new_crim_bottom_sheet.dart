import 'dart:io';

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/dialog/loading_screen.dart';
import 'package:alerta_criminal/core/providers/location_notifier.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/date_util.dart';
import 'package:alerta_criminal/core/utils/location_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/address.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/data/models/crime_type.dart';
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
    void Function() resetLocation,
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
            resetLocation: resetLocation,
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
    required this.resetLocation,
  });

  final void Function(CrimeModel crim) addNewCrim;
  final void Function() resetLocation;

  @override
  ConsumerState<_AddNewCrimBottomSheet> createState() {
    return _AddNewCrimBottomSheetState();
  }
}

class _AddNewCrimBottomSheetState extends ConsumerState<_AddNewCrimBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final crimeTypeController = TextEditingController();
  late LatLng? userLocation;
  String? crimeAddress;
  LatLng? userPreviousLocation;
  late DateTime currentDate;
  late TimeOfDay currentTime;
  var selectedCrimeType = crimeTypes.first;
  var isPreciseLocation = true;
  var isSubmiting = false;
  late LoadingScreen loadingScreen;

  File? image;

  @override
  void initState() {
    loadingScreen = LoadingScreen.instance();
    setDateAndTime();
    super.initState();
  }

  @override
  void dispose() async {
    if (!isPreciseLocation) {
      Future.delayed(const Duration(milliseconds: 300), () => widget.resetLocation());
    }
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void submit() {
    final formInvalid = !formKey.currentState!.validate();

    if (formInvalid) {
      return;
    }

    setState(() {
      isSubmiting = true;
    });

    loadingScreen.show(context: context);

    addCrim();
  }

  void addCrim() async {
    final crim = await getCrimeCreatedByUser();
    widget.addNewCrim(crim);

    if (!context.mounted) {
      return;
    }

    loadingScreen.hide();

    Navigator.pop(context);
  }

  Future<CrimeModel> getCrimeCreatedByUser() async {
    final pickedDate =
    DateTime(currentDate.year, currentDate.month, currentDate.day, currentTime.hour, currentTime.minute);

    final crime =  CrimeModel(
    title: titleController.text,
    description: descriptionController.text,
    lat: userLocation!.latitude,
    lng: userLocation!.longitude,
    address: crimeAddress ??=
        await DependencyInjection.locationUseCase.getAddressByLatLng(userLocation!.latitude, userLocation!.longitude),
    crimeTypeId: selectedCrimeType.id,
    userId: getCurrentUser()!.uid,
    date: pickedDate,
  );

    if (image != null) {
      final imageUrl = await DependencyInjection.userDataUseCase.saveCrimImage(image!, crime.id);
      crime.imageUrl = imageUrl;
    }

    return crime;
  }

  void setDateAndTime() {
    currentDate = DateTime.now();
    currentTime = TimeOfDay(hour: currentDate.hour, minute: currentDate.minute);
    dateController.text = formatDate(currentDate);
    timeController.text = formatTime(currentTime);
  }

  void selectLocationOnMap() async {
    final address = await Navigator.of(context).push<Address>(
      MaterialPageRoute(
        builder: (context) => SetAddressOnMapScreen(
          markers: {Marker(markerId: const MarkerId("m1"), position: userLocation!)},
          userLocation: userLocation!,
        ),
      ),
    );

    if (address == null) {
      return;
    }

    ref.read(locationProvider.notifier).setLocation(address.location);
    crimeAddress = address.name;
    isPreciseLocation = false;
  }

  void selectDate() async {
    final pickedDate = await openDatePicker(context);

    if (pickedDate == null) {
      return;
    }

    currentDate = pickedDate;

    setState(() {
      dateController.text = formatDate(pickedDate);
    });
  }

  void setTimePicker() async {
    final pickedTime = await openTimePicker(context);

    if (pickedTime == null) {
      return;
    }

    currentTime = pickedTime;

    setState(() {
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
            photoPreviewWidget(),
            form(context, verticalSpacing),
            verticalSpacing,
            crimeLocationText(context),
            locationPreview(context),
            verticalSpacing,
            Row(
              children: [
                crimeTypeDropdown(),
                const Spacer(),
                sendButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton sendButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary,),
      onPressed: isSubmiting ? null : submit,
      label: Text(getStrings(context).send),
    );
  }

  Stack locationPreview(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
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
              onPressed: selectLocationOnMap,
              icon: Icon(
                Icons.map_rounded,
                color: CustomColors().blue,
              ),
            ),
          ),
        )
      ],
    );
  }

  SizedBox crimeLocationText(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Opacity(
        opacity: 0.8,
        child: Text(
          getStrings(context).crimeLocale,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Form form(BuildContext context, Widget verticalSpacing) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          titleField(context),
          verticalSpacing,
          descriptionField(context),
          verticalSpacing,
          Row(
            children: [
              dateField(context),
              const SizedBox(
                width: 8,
              ),
              hourField(context),
            ],
          )
        ],
      ),
    );
  }

  DropdownMenu<CrimeType> crimeTypeDropdown() {
    return DropdownMenu<CrimeType>(
      initialSelection: crimeTypes.first,
      controller: crimeTypeController,
      requestFocusOnTap: true,
      label: const Text('Tipo de crime'),
      onSelected: (CrimeType? crimeType) {
        setState(() {
          selectedCrimeType = crimeType!;
        });
      },
      keyboardType: TextInputType.none,
      dropdownMenuEntries: crimeTypes.map<DropdownMenuEntry<CrimeType>>((CrimeType crimeType) {
        return DropdownMenuEntry<CrimeType>(
          value: crimeType,
          label: crimeType.label,
          // style: MenuItemButton.styleFrom(
          //   foregroundColor: crimeType.color,
          // ),
        );
      }).toList(),
    );
  }

  Flexible hourField(BuildContext context) {
    return Flexible(
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
    );
  }

  Flexible dateField(BuildContext context) {
    return Flexible(
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
        onTap: selectDate,
      ),
    );
  }

  TextFormField descriptionField(BuildContext context) {
    return TextFormField(
      maxLines: 4,
      controller: descriptionController,
      validator: (value) {
        if (value == null || value.trim().isEmpty || value.trim().length < 10) {
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
    );
  }

  TextFormField titleField(BuildContext context) {
    return TextFormField(
      controller: titleController,
      validator: (value) {
        if (value == null || value.trim().isEmpty || value.trim().length < 4) {
          return getStrings(context).addCrimTitleError;
        }
        return null;
      },
      decoration: InputDecoration(labelText: getStrings(context).title),
    );
  }

  PhotoPreviewWidget photoPreviewWidget() => PhotoPreviewWidget(setImage: (img) => image = img);
}
