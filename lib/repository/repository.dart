import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/auth_base.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/firebase_auth_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/storage_service/firebase_storage_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/firestore_service/firestore_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class Repository implements AuthBase {
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreServices fireStoreService = locator<FirestoreServices>();
  FirebaseStorageService firebaseStorage = locator<FirebaseStorageService>();

  List<UserModel> tumKullanicilarListesi = [];

  @override
  Future<UserModel?> currentUser() async {
    UserModel? userModel = await firebaseAuthService.currentUser();
    if (userModel != null) {
      return await fireStoreService.readUser(userModel.userId);
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> singInAnonymously() async {
    return await firebaseAuthService.singInAnonymously();
  }

  @override
  Future<bool> singOut() async {
    return await firebaseAuthService.singOut();
  }

  @override
  Future<UserModel?> googleWithSingIn() async {
    UserModel? usermodel = await firebaseAuthService.googleWithSingIn();
    if (usermodel != null) {
      bool result = await fireStoreService.saveUser(usermodel);
      if (result) {
        return await fireStoreService.readUser(usermodel.userId);
      }
    }
    return null;
  }

// oluşturulan kullanıcının id değerini firestora kaydetmek istiyorum. bu nedenle bu işlemi repoda gerçekleştirdim.
  @override
  Future<UserModel?> createUserWithSingIn(String email, String password) async {
    UserModel? usermodel =
        await firebaseAuthService.createUserWithSingIn(email, password);
    bool result = await fireStoreService.saveUser(usermodel!);
    if (result) {
      return await fireStoreService.readUser(usermodel.userId);
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> emailAndPasswordWithSingIn(
      String email, String password) async {
    UserModel? usermodel =
        await firebaseAuthService.emailAndPasswordWithSingIn(email, password);
    return await fireStoreService.readUser(usermodel!.userId);
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    return await fireStoreService.updateUserName(userId, newUserName);
  }

  Future<String> uploadFile(
      String userId, String fileType, File? profilePhoto) async {
    var profilPhotoUrl =
        await firebaseStorage.uploadFile(userId, fileType, profilePhoto!);
    await fireStoreService.updateProfilePhoto(userId, profilPhotoUrl);
    return profilPhotoUrl;
  }

  Stream<List<MesajModel>> getMessagers(
      String currentUserId, String sohbetEdilenUserId) {
    return fireStoreService.getMessages(currentUserId, sohbetEdilenUserId);
  }

  Future<bool> saveMessages(MesajModel kaydedilecekMesaj) async {
    return await fireStoreService.saveMessages(kaydedilecekMesaj);
  }

  Future<List<KonusmaModel>> getAllConversations(String userId) async {
    DateTime zaman = await fireStoreService.showTime(userId);
    var konusmaListesi = await fireStoreService.getAllConversations(userId);
    //konusmaModel sınıfımda kullanıcının username ve profilUrl değerini tutmadığım için, bu değerleri userModel sınıfından alıp kullanmaya çalışaçağım.bu nedenle yukarıda her yerden erişebileceğim tumKullanicilarListesi  listesini olusturdum.daha sonra userModeldeki bu verileri konusmaModele atayarak verileri istediğim verilere erişim sağladım.aşagıda  intarnete çıkmadan ve çıkarak ortamın durumuna göre verilere erişim sağlanıyor.//
    for (var oankiKonusma in konusmaListesi) {
      var userListesindekiKullanici =
          listedeUserBul(oankiKonusma.kimle_konusuyor);

      debugPrint("VERİLER VERİTABANINDAN  OKUNDU");
      var veritabanindanOkunanUser =
          await fireStoreService.readUser(oankiKonusma.kimle_konusuyor);
      oankiKonusma.konusulanUserName = veritabanindanOkunanUser.userName;
      oankiKonusma.konusulanUserProfilUrl = veritabanindanOkunanUser.profilUrl;
      timeAgoHesapla(oankiKonusma, zaman);
    }
    return konusmaListesi;
  }

  void timeAgoHesapla(KonusmaModel oankiKonusma, DateTime zaman) {
    oankiKonusma.son_okuma_zamani = zaman;
    var duration = zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.saat_farki = timeago.format(zaman.subtract(duration));
  }

  UserModel? listedeUserBul(String userId) {
    // tüm elemanları gezerken ki userId ile kullanıcının userIdsi eşitse  bilgilerini getir.
    for (int i = 0; i < tumKullanicilarListesi.length; i++) {
      if (tumKullanicilarListesi[i].userId == userId) {
        return tumKullanicilarListesi[i];
      }
    }
    return null;
  }

  Future<List<UserModel>> getUserWithPagination(
      UserModel? ensonGetirilenUser, int getirilecekElemanSayisi) async {
    List<UserModel> userList = await fireStoreService.getUserWithPagination(
        ensonGetirilenUser, getirilecekElemanSayisi);
    tumKullanicilarListesi.addAll(userList);
    return userList;
  }

  Future<bool> chatDelete(
      String currentUserId, String sohbetEdilenUserId) async {
    return await fireStoreService.chatDelete(currentUserId, sohbetEdilenUserId);
  }
}
