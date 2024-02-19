import 'package:flutter_firebase_crashlytics_usage/repository/repository.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/fake_auth_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/firebase_auth_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/storage_service/firebase_storage_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/firestore_service/firestore_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;
void getItLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService(),);
  locator.registerLazySingleton(() => FakeAuthService(),);
  locator.registerLazySingleton(() => Repository(),);
  locator.registerLazySingleton(() => FirestoreServices(),);
  locator.registerLazySingleton(() => FirebaseStorageService(),);



}
