import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key, this.image, required this.onImagePicked, required this.networkUrl});
  final File? image;
  final Function(File? pickedImage) onImagePicked;
  final String? networkUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 150,
      borderRadius: 150.borderRadius,
      onTap: () async {
        var picker = ImagePicker();
        final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          onImagePicked(File(image.path));
        } else {
          onImagePicked(null);
        }
      },
      child: Container(
        width: 150,
        height: 150,
        child: PhysicalModel(
          color: Colors.white,
          borderRadius: 150.borderRadius,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: image != null
                  ? Image.file(
                image!,
                height: context.screenWidth * 0.12,
                width: context.screenHeight * 0.12,
                fit: BoxFit.cover,
              )
                  : networkUrl != null ? PhysicalModel(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(150),
                    child: CachedNetworkImage(
                      imageUrl:
                      networkUrl ?? '',
                      width: context.screenWidth * 0.12,
                      height: context.screenHeight * 0.12,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget:
                          (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                  ),
                ),
              ): Container(
                height: context.screenWidth * 0.12,
                width: context.screenHeight * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: Icon(
                  Icons.person,
                  size: context.screenHeight * 0.06,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
