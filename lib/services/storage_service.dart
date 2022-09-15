import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:random_string/random_string.dart';

class StorageService {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<String> uploadFile(File file, {required String bucketName, required String folderName}) async {
    String random = '';
    String downloadURL = '';
    String fileName = basename(file.path);
    String path = fileName;
    if (fileName.length < 10) {
      random = randomNumeric(10 - fileName.length);
      path = '$random$fileName';
    }

    await storage
        .ref()
        .child('$bucketName/$folderName')
        .child(path)
        .putFile(file)
        .then((taskSnapshot) async => downloadURL = await taskSnapshot.ref.getDownloadURL());

    return downloadURL;
  }
}
