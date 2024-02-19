import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/auth_base.dart';

class FakeAuthService implements AuthBase {
  final String userId = "1231321121210";
  @override
  Future<UserModel> currentUser() {
    return Future.value(
      UserModel(userId: userId, email: "fake@gmail.com"),
    );
  }

  @override
  Future<UserModel> singInAnonymously() async {
    return await Future.delayed(
      Duration(seconds: 2),
      () => UserModel(userId: userId, email: "fake@gmail.com"),
    );
  }

  @override
  Future<bool> singOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel?> googleWithSingIn() async {
    return await Future.delayed(
      Duration(seconds: 2),
      () => UserModel(userId: userId, email: "fake@gmail.com"),
    );
  }

  @override
  Future<UserModel?> createUserWithSingIn(String email, String password) {
    // TODO: implement createUserWithSingIn
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> emailAndPasswordWithSingIn(String email, String password) {
    // TODO: implement emailAndPasswordWithSingIn
    throw UnimplementedError();
  }
}
