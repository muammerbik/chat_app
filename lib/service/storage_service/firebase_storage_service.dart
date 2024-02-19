import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_crashlytics_usage/service/storage_service/storage_base.dart';

class FirebaseStorageService implements FireBaseStorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(
      String userId, String fileType, File yuklenecekDosya) async {
    Reference reference = _firebaseStorage
        .ref()
        .child(userId)
        .child(fileType)
        .child("profil_photo.png");

    UploadTask uploadTask = reference.putFile(yuklenecekDosya);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
