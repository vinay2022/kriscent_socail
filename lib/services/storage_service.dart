import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

enum MediaType {
  image,
  video,
}

class StorageService {
  StorageService({required this.collectionName});
  final String collectionName;
  Future<String> uploadMedia(
      {required File file,
        required String fileName,
        required MediaType type}) async {
    Reference reference;
    UploadTask uploadTask;
    if (type == MediaType.image) {
      reference =
          FirebaseStorage.instance.ref().child('$collectionName/$fileName.jpg');
      uploadTask =
          reference.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    }
    else {
      reference =
          FirebaseStorage.instance.ref().child('$collectionName/$fileName.mp4');
      uploadTask =
          reference.putFile(file, SettableMetadata(contentType: 'video/mp4'));
    }
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
