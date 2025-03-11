import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends ConsumerWidget {
  const ImageInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ImagePicker imagePicker = ImagePicker();

    void clickPicture() async {
      final pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 600);
      if (pickedImage == null) {
        return;
      }
      final storageRef =
            FirebaseStorage.instance.ref().child('user_images').child(
                  '${Random().nextInt(1000).toString()}.jpg',
                );
      await storageRef.putFile(File(pickedImage.path));
    }

    return InkWell(
      onTap: clickPicture,
      child: CircleAvatar(
        radius: 35,
        backgroundImage: clickedImage.photoUrl.path.isEmpty
            ? Image.asset('assets/pfp.jpeg').image
            : FileImage(File(clickedImage.photoUrl.path)),
      ),
    );
  }
}
