//katmanlı mimari ile yazılan kodların bakımı  ve kullanımı daha kolaydır. aut işlemleri için katmanlı mimari kullanmıştık, firestore içinde ayrı bir katmanlı mimari kullanacağız.
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';

abstract class DbBase {
  Future<bool> saveUser(UserModel userModel);

  Future<UserModel> readUser(String userId);

  Future<bool> updateUserName(String userId, String newUserName);

  Future<bool> updateProfilePhoto(String userId, String profilPhotoUrl);

  //Future<List<UserModel>> getAllUser();
  //verilerin futureBuilder ile hepsi birden geliyordu.Pagination ile verilerin hepsini birden getirmek yerine gerektiği kadar getirdim.
  Future<List<UserModel>> getUserWithPagination(
      UserModel ensonGetirilenUser, int getirilecekElemanSayisi);

  Stream<List<MesajModel>> getMessages(
      String currentUserId, String sohbetEdilenUserId);

  Future<bool> saveMessages(MesajModel kaydedilecekMesaj);

  Future<List<KonusmaModel>> getAllConversations(String userId);
}
