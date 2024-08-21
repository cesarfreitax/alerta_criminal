import 'dart:io';

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/crim_model.dart';
import 'package:alerta_criminal/domain/entities/crim_entity.dart';
import 'package:alerta_criminal/features/home/widgets/photo_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddNewCrimBottomSheet {
  Future<dynamic> show(
    BuildContext ctx,
    void Function(CrimEntity crim) addNewCrim,
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
        isScrollControlled: true);
  }
}

class _AddNewCrimBottomSheet extends StatefulWidget {
  const _AddNewCrimBottomSheet({
    required this.addNewCrim,
    required this.location,
  });

  final void Function(CrimEntity crim) addNewCrim;
  final LatLng location;

  @override
  State<_AddNewCrimBottomSheet> createState() {
    return _AddNewCrimBottomSheetState();
  }
}

class _AddNewCrimBottomSheetState extends State<_AddNewCrimBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  File? image;
  var title = "";
  var description = "";

  // late LatLng location;

  void submit() {
    final formInvalid = !formKey.currentState!.validate();
    if (formInvalid) {
      return;
    }

    addNewCrim();
  }

  void addNewCrim() async {
    final model = CrimModel(
      title: title,
      description: description,
      location: widget.location,
    );

    if (image != null) {
      DependencyInjection.userDataUseCase.saveCrimImage(image!, getCurrentUser().uid);
    }

    final entity = model.toEntity();
    widget.addNewCrim(entity);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
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
            Form(
              key: formKey,
              child: Column(
                children: [
                  PhotoPreviewWidget(setImage: (img) => image = img),
                  verticalSpacing,
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
                    decoration: InputDecoration(
                        labelText: getStrings(context).title),
                  ),
                  verticalSpacing,
                  TextFormField(
                    maxLines: 4,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        alignLabelWithHint: true),
                  ),
                ],
              ),
            ),
            verticalSpacing,
            Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  onPressed: submit,
                  label: const Text('Send'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
