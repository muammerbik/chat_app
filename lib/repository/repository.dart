import 'dart:io';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/auth_base.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/fake_auth_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/firebase_auth_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/storage_service/firebase_storage_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/firestore_service/firestore_service.dart';

enum AppMode { DEBUG, RELEASE }

class Repository implements AuthBase {
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService fakeAuthService = locator<FakeAuthService>();
  FirestoreServices fireStoreService = locator<FirestoreServices>();
  FirebaseStorageService firebaseStorage = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await fakeAuthService.currentUser();
    } else {
      UserModel? userModel = await firebaseAuthService.currentUser();
      return await fireStoreService.readUser(userModel!.userId);
    }
  }

  @override
  Future<UserModel?> singInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await fakeAuthService.singInAnonymously();
    } else {
      return await firebaseAuthService.singInAnonymously();
    }
  }

  @override
  Future<bool> singOut() async {
    if (appMode == AppMode.DEBUG) {
      return await fakeAuthService.singOut();
    } else {
      return await firebaseAuthService.singOut();
    }
  }

  @override
  Future<UserModel?> googleWithSingIn() async {
    if (appMode == AppMode.DEBUG) {
      return await fakeAuthService.googleWithSingIn();
    } else {
      UserModel? usermodel = await firebaseAuthService.googleWithSingIn();
      // google ile giriş yaptıktan sonra  verileri firebase firestore kaydettim. Ardından kaydedilen verileri okudum terminalde gösterdim.
      bool result = await fireStoreService.saveUser(usermodel!);

      if (result) {
        return await fireStoreService.readUser(usermodel.userId);
      } else {
        return null;
      }
    }
  }

// oluşturulan kullanıcının id değerini firestora kaydetmek istiyorum. bu nedenle bu işlemi repoda gerçekleştirdim.
  @override
  Future<UserModel?> createUserWithSingIn(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await fakeAuthService.createUserWithSingIn(email, password);
    } else {
      UserModel? usermodel =
          await firebaseAuthService.createUserWithSingIn(email, password);
      bool result = await fireStoreService.saveUser(usermodel!);
      if (result) {
        //veritabanına eklenen id değerlerini aldım
        return await fireStoreService.readUser(usermodel.userId);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> emailAndPasswordWithSingIn(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await fakeAuthService.emailAndPasswordWithSingIn(email, password);
    } else {
      UserModel? usermodel =
          await firebaseAuthService.emailAndPasswordWithSingIn(email, password);
      return await fireStoreService.readUser(usermodel!.userId);
    }
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await fireStoreService.updateUserName(userId, newUserName);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File? profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var profilPhotoUrl =
          await firebaseStorage.uploadFile(userId, fileType, profilePhoto!);
      await fireStoreService.updateProfilePhoto(userId, profilPhotoUrl);
      return profilPhotoUrl;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var tumKullanicilarListesi = await fireStoreService.getAllUser();
      return tumKullanicilarListesi;
    }
  }
}
