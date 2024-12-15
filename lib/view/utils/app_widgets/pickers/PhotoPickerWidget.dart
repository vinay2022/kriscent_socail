import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';

class PhotoPickerWidget extends StatelessWidget {
  const PhotoPickerWidget({
    super.key,
    this.photo,
    required this.onPhotoPicked,
  });

  final File? photo;
  final Function(File? pickedPhoto) onPhotoPicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var picker = ImagePicker();
        final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);
        if (imageFile != null) {
          onPhotoPicked(File(imageFile.path));
        } else {
          onPhotoPicked(null);
        }
      },
      child: Container(
        width: context.screenWidth * 0.9,
        height: context.screenHeight * 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: photo != null
              ? Image.file(photo!, fit: BoxFit.cover)
              : Container(
            color: Colors.grey,
            child: Icon(
              Icons.photo_outlined,
              size: context.screenHeight * 0.06,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
