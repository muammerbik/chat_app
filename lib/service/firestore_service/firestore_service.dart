import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/service/firestore_service/db_base.dart';

class FirestoreServices implements DbBase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel userModel) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.doc("users/${userModel.userId}").get();
    if (documentSnapshot.data() == null) {
      await firestore
          .collection("users")
          .doc(userModel.userId)
          .set(userModel.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<UserModel> readUser(String userId) async {
    DocumentSnapshot okunanUser =
        await firestore.collection("users").doc(userId).get();
    Map<String, dynamic>? okunanUserBilgileriMap =
        okunanUser.data() as Map<String, dynamic>?;
    UserModel okunanUserNesnesi = UserModel.fromMap(okunanUserBilgileriMap!);
    debugPrint("okunan user nesnesi$okunanUserNesnesi");
    return okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userId, String newUserName) async {
    var users = await firestore
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await firestore
          .collection("users")
          .doc(userId)
          .update({"userName": newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String profilPhotoUrl) async {
    await firestore
        .collection("users")
        .doc(userId)
        .update({"profilUrl": profilPhotoUrl});
    return true;
  }

  @override
//sohbet ettiğim tüm kullanıcıları bir listeye aldım ve bu listeyi chatPage de göstereceğim.
  Future<List<KonusmaModel>> getAllConversations(String userId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("konusanlar")
        .where("konusma_sahibi", isEqualTo: userId)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    List<KonusmaModel> conversationsList = [];

    for (DocumentSnapshot talkUser in querySnapshot.docs) {
      var data = talkUser.data();
      if (data is Map<String, dynamic>) {
        KonusmaModel talkUser = KonusmaModel.fromMap(data);
        conversationsList.add(talkUser);
      }
    }
    return conversationsList;
  }

  //Stream yapısı anlık olarak verileri dinlemek için kullanılır, İçerisinde mesajlar olan bir liste döndürdüm.Sohbetteki tüm mesajları almamı sağlayacak.
  @override
  Stream<List<MesajModel>> getMessages(String currentUserId, String sohbetEdilenUserId) {
    var snapshot = firestore
        .collection("konusanlar")
        .doc("$currentUserId--$sohbetEdilenUserId")
        .collection("mesajlar")
        .orderBy("date")
        .snapshots();
    return snapshot.map(
      (snapshot) => snapshot.docs
          .map(
            (event) => MesajModel.fromMap(
              event.data(),
            ),
          )
          .toList(),
    );
  }

  // Mesajlaşma iki kişi arsında olan birseydir.Mesaj gönderen ve mesaj alan kişiler vardır.ve ortada bir mesaj dökümanı olmalı.mesaj gönderen ve mesaj alan kişileri doc olarak iki kere karşılıklı kaydetmemiz gerek. Bunun sebebi kullanıcılardan biri mesajları sildiğinde silmeyen kişideki verilerin gidebileceğindendir
  // mesajı db ye kaydederken iki farklı yere kaydedip, farklı idler vermem gerekiyor.
  @override
  Future<bool> saveMessages(MesajModel kaydedilecekMesaj) async {
    var mesajId = firestore.collection("konusanlar").doc().id;
    //yazılan mesajı içinde barındıracak bir alt id olusturdum.
    //mesajlaşma karşıklı olacağı için ,karşılıklı olarak yazılacak mesajları kaydettim.
    var myDocumentId = "${kaydedilecekMesaj.kimden}--${kaydedilecekMesaj.kime}";
    var receiverDocumentId ="${kaydedilecekMesaj.kime}--${kaydedilecekMesaj.kimden}";
    var kaydedilecekIdninMapi = kaydedilecekMesaj.toMap();

    await firestore
        .collection("konusanlar")
        .doc(myDocumentId)
        .collection("mesajlar")
        .doc(mesajId)
        .set(kaydedilecekIdninMapi);
     kaydedilecekIdninMapi.update("bendenMi", (value) => false);

    await firestore
        .collection("konusanlar")
        .doc(receiverDocumentId)
        .collection("mesajlar")
        .doc(mesajId)
        .set(kaydedilecekIdninMapi);
    /*
      .Kullanıcılar sayfasında kayıtlı olan herkesi görüyorken, sohbet alanında sadece mesajlaştığım kullanıcıları görmek istiyorum.bu yüzden tüm kullanıcılar içinden konuştuklarımı filtrelemeye çalıştığımda firebase çok fazla okuma yapmış oluyor. Okumadan tasarruf edip sadece sohbet ettiğim kullanıcıları almak için konusanlar collectionundan oanki kullanıcı ve sohbet ettiği kişi için yeni bir döküman oluşturdum.Sohbet eden kullanıcıların ikisi de bu verilere sahip olsun diye hem oanki user hemde sohbet edilen için id kullanarak bu verileri kaydettim.
       */
    await firestore.collection("konusanlar").doc(myDocumentId).set({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_görüldü": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    await firestore.collection("konusanlar").doc(receiverDocumentId).set({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_görüldü": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<UserModel>> getUserWithPagination(UserModel? enSoongetirilenUser, int getirilecekElemanSayisi) async {
    QuerySnapshot querySnapshot;
    List<UserModel> allUserList = [];
    if (enSoongetirilenUser == null) {
      // ilk gelecek on eleman için
      debugPrint("ilk defa kullanıcılar getirliliyor");
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      // ilk gelen 10 elemandan sonraki elemanlar için. enson gelen isimden sonra  yeni elemanlar gelecekk,
      debugPrint("Sonraki kullanıcılar getirliliyor");
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSoongetirilenUser.userName])
          .limit(getirilecekElemanSayisi)
          .get();
      await Future.delayed(
        const Duration(seconds: 1),
      );
    }
    for (DocumentSnapshot snap in querySnapshot.docs) {
      var data = snap.data();
      if (data is Map<String, dynamic>) {
        UserModel tekUser = UserModel.fromMap(data);
        allUserList.add(tekUser);
        debugPrint("getirilien user name ${tekUser.userName!}");
      }
    }
    return allUserList;
  }

  @override
  Future<DateTime> showTime(String userId) async {
    await firestore
        .collection("server")
        .doc(userId)
        .set({"saat": FieldValue.serverTimestamp()});
    var okunanMap = await firestore.collection("server").doc(userId).get();
    Map<String, dynamic>? data = okunanMap.data();
    if (data != null) {
      Timestamp okunanTarih = data["saat"];
      return okunanTarih.toDate();
    } else {
      throw Exception("Data not found");
    }
  }

  @override
  Future<bool> chatDelete(String currentUserId, String sohbetEdilenUserId) async {
    String chatId = "$currentUserId--$sohbetEdilenUserId";
    String reverseChatId = "$sohbetEdilenUserId--$currentUserId";

    try {
      // Konuşmayı sil
      await firestore.collection("konusanlar").doc(chatId).delete();
      await firestore.collection("konusanlar").doc(reverseChatId).delete();

      // Mesajları sil
      var messagesSnapshot = await firestore
          .collection("konusanlar")
          .doc(chatId)
          .collection("mesajlar")
          .get();
      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      debugPrint("Sohbet silme hatası: $e");
      return false;
    }
  }
}
