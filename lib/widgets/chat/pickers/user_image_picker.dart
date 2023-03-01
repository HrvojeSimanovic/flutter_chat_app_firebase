import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPickerImage extends StatefulWidget {
  final void Function(File image) imagePickFn;

  const UserPickerImage(this.imagePickFn, {Key? key}) : super(key: key);

  @override
  _UserPickerImageState createState() => _UserPickerImageState();
}

class _UserPickerImageState extends State<UserPickerImage> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  void _pickImage() async {
    final XFile? takenImageFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      if (takenImageFile != null) {
        _pickedImage = File(takenImageFile.path);
      }
    });
    if (_pickedImage != null) {
      widget.imagePickFn(_pickedImage!);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo_camera),
          label: const Text('Take a picture'),
        ),
      ],
    );
  }
}
