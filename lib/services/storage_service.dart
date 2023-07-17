import 'dart:io';

import 'package:alcohol_inventory/services/snackbar_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadProfileImage(
      File file, String fileName, String folder) async {
    String path = '$folder/$fileName';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    SnackBarService.instance.showSnackBarSuccess('Image uploaded');
    return downloadLink;
  }
}
