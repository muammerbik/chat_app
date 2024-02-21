import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/service/firestore_service/db_base.dart';

class FirestoreServices implements DbBase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<bool> saveUser(UserModel userModel) async {
    // createdAT ve upDateAt değerleri kullanıcıdan gelmesini istemiyorumda fireStoreden gelmesini istiyorum bu nedenle bu değerleri firestordan alacağız. değerleri map olarak alacağımız için önce nesnemizi mapa cevirelim ve sonra değerimizi alalım. ama bunu userModel de yazsan daha sağlıklı olur.
/* 
    Map<String, dynamic> ekleneecekUserModel = userModel.toMap();
    ekleneecekUserModel["createdAt"] = FieldValue.serverTimestamp();
    ekleneecekUserModel["updatedAt"] = FieldValue.serverTimestamp(); */

    await firestore
        .collection("users")
        .doc(userModel.userId)
        .set(userModel.toMap());
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.doc("users/${userModel.userId}").get();

    Map<String, dynamic>? geleenData = documentSnapshot.data();
    UserModel geleenDataModeli = UserModel.fromMap(geleenData!);
    print(
      "okunan user nesnesi  " + geleenDataModeli.toString(),
    );
    return true;
  }

  @override
  Future<UserModel> readUser(String userId) async {
    DocumentSnapshot okunanUser =
        await firestore.collection("users").doc(userId).get();

    Map<String, dynamic>? okunanUserBilgileriMap =
        okunanUser.data() as Map<String, dynamic>?;
    UserModel okunanUserNesnesi = UserModel.fromMap(okunanUserBilgileriMap!);
    print("okunan user nesnesi" + okunanUserNesnesi.toString());
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

  Future<bool> updateProfilePhoto(String userId, String profilPhotoUrl) async {
    await firestore
        .collection("users")
        .doc(userId)
        .update({"profilUrl": profilPhotoUrl});
    return true;
  }

  /*  @override
  Future<List<UserModel>> getAllUser() async {
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    List<UserModel> tumKullaniciList = [];

    for (DocumentSnapshot tekUser in querySnapshot.docs) {
      UserModel _tekUser = UserModel.fromMap(tekUser.data());
      tumKullaniciList.add(_tekUser);
    }

 /*    tumKullaniciList =
        querySnapshot.docs.map((e) => UserModel.fromMap(e.data())).toList(); */

    return tumKullaniciList;
  } */

  //firestordaki  tüm kullanıcıları  tek tek gezdim ve ekranda yazdırmak için listeledim.
  @override
  Future<List<UserModel>> getAllUser() async {
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    List<UserModel> tumKullaniciList = [];

    for (DocumentSnapshot tekUser in querySnapshot.docs) {
      var data = tekUser.data();
      if (data is Map<String, dynamic>) {
        UserModel _tekUser = UserModel.fromMap(data);
        tumKullaniciList.add(_tekUser);
      }
    }

    return tumKullaniciList;
  }
}
