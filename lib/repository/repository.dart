import 'dart:io';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/auth_base.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/fake_auth_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/firebase_auth_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/storage_service/firebase_storage_service.dart';
import 'package:flutter_firebase_crashlytics_usage/service/firestore_service/firestore_service.dart';

import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class Repository implements AuthBase {
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService fakeAuthService = locator<FakeAuthService>();
  FirestoreServices fireStoreService = locator<FirestoreServices>();
  FirebaseStorageService firebaseStorage = locator<FirebaseStorageService>();
 
  AppMode appMode = AppMode.RELEASE;

  List<UserModel> tumKullanicilarListesi = [];

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

  Future<String> uploadFile(String userId, String fileType, File? profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var profilPhotoUrl =
          await firebaseStorage.uploadFile(userId, fileType, profilePhoto!);
      await fireStoreService.updateProfilePhoto(userId, profilPhotoUrl);
      return profilPhotoUrl;
    }
  }

  Stream<List<MesajModel>> getMessagers(String currentUserId, String sohbetEdilenUserId) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return fireStoreService.getMessages(currentUserId, sohbetEdilenUserId);
    }
  }

  Future<bool> saveMessages(MesajModel kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await fireStoreService.saveMessages(kaydedilecekMesaj);
    }
  }

  Future<List<KonusmaModel>> getAllConversations(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await fireStoreService.showTime(userId);
      var konusmaListesi = await fireStoreService.getAllConversations(userId);
      //konusmaModel sınıfımda kullanıcının username ve profilUrl değerini tutmadığım için, bu değerleri userModel sınıfından alıp kullanmaya çalışaçağım.bu nedenle yukarıda her yerden erişebileceğim tumKullanicilarListesi  listesini olusturdum.daha sonra userModeldeki bu verileri konusmaModele atayarak verileri istediğim verilere erişim sağladım.aşagıda  intarnete çıkmadan ve çıkarak ortamın durumuna göre verilere erişim sağlanıyor.
//
      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeUserBul(oankiKonusma.kimle_konusuyor);
        if (userListesindekiKullanici != null) {
          print("VERİLER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfilUrl =
              userListesindekiKullanici.profilUrl;
        } else {
          print("VERİLER VERİTABANINDAN  OKUNDU");
          var veritabanindanOkunanUser =
              await fireStoreService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = veritabanindanOkunanUser.userName;
          oankiKonusma.konusulanUserProfilUrl =
              veritabanindanOkunanUser.profilUrl;
        }
        timeAgoHesapla(oankiKonusma, _zaman);
      }
      return konusmaListesi;
    }
  }

  void timeAgoHesapla(KonusmaModel oankiKonusma, DateTime zaman) {
    oankiKonusma.son_okuma_zamani = zaman;
    var _duration = zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.saat_farki = timeago.format(zaman.subtract(_duration));
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

  Future<List<UserModel>> getUserWithPagination(UserModel? ensonGetirilenUser, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<UserModel> _userList = await fireStoreService.getUserWithPagination(ensonGetirilenUser, getirilecekElemanSayisi);
      tumKullanicilarListesi.addAll(_userList);
      return _userList;
    }
  }
}
