import 'dart:io';

abstract class FireBaseStorageBase {
  Future<String> uploadFile(
      String userId, String fileType, File yuklenecekDosya);
}
