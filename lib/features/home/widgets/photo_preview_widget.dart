import 'dart:io';

import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPreviewWidget extends StatefulWidget {
  const PhotoPreviewWidget({super.key, required this.setImage});

  final void Function(File image) setImage;

  @override
  State<PhotoPreviewWidget> createState() {
    return _PhotoPreviewWidgetState();
  }
}

class _PhotoPreviewWidgetState extends State<PhotoPreviewWidget> {
  XFile? imagePreview;
  void takePicture() async {
    final XFile? picture = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
      imageQuality: 60,
    );

    if (picture == null) {
      return;
    }

    setState(() {
      imagePreview = picture;
    });

    final imageFile = File(picture.path);

    widget.setImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imagePreview != null)
          Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                2,
              ),
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: imagePreview != null
              ? Image.file(
                  File(imagePreview!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : null,
        ),
          const SizedBox(
            height: 16,
          ),
        OutlinedButton.icon(
          onPressed: takePicture,
          label: Text(getStrings(context).takePicture),
          icon: const Icon(Icons.camera_alt),
        )
      ],
    );
  }
}
