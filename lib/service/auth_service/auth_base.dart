import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';

abstract class AuthBase {
  Future<UserModel?> currentUser();
  Future<UserModel?> singInAnonymously();
  Future<bool> singOut();
  Future<UserModel?> googleWithSingIn();
  Future<UserModel?> emailAndPasswordWithSingIn(String email, String password);
  Future<UserModel?> createUserWithSingIn(String email, String password);

}
