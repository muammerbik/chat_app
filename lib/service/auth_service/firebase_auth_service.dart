import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        return _userFromFirebase(user);
      }
      return null;
    } catch (e) {
      debugPrint("current User hata: $e");
      return null;
    }
  }

  UserModel? _userFromFirebase(User user) {
    return UserModel(
      userId: user.uid,
      email: user.email.toString(),
    );
  }

  @override
  Future<UserModel?> singInAnonymously() async {
    try {
      var userCredential = await firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user!);
    } catch (e) {
      debugPrint("singInAnonymously hattaaa" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      googleSignIn.signOut();
      //firebaseden de çıkıs yapmak için yazdım!
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("hataaa signOut" + e.toString());
    }
    return false;
  }

  Future<UserModel?> googleWithSingIn() async {
    try {
      // Google ile giriş yap
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Google kimlik doğrulama bilgilerini al
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Firebase Authentication'a giriş yap
        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        // Oluşturulan kullanıcıyı döndür
        final User? user = userCredential.user;
        if (user != null) {
          return UserModel(
            userId: user.uid,
            email: user.email.toString(),
            // Diğer kullanıcı bilgilerini burada alabilirsiniz
          );
        }
      } else {
        // Google girişi iptal edildiğinde null döndür
        return null;
      }

      return null;
    } catch (e) {
      print('Google ile giriş yaparken hata oluştu: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> createUserWithSingIn(String email, String password) async {
    var userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(userCredential.user!);
  }

  @override
  Future<UserModel?> emailAndPasswordWithSingIn(
      String email, String password) async {
    var userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(userCredential.user!);
  }
}
