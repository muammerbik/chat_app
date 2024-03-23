import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/repository/repository.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/auth_base.dart';

enum ViewState { idly, busy }

class UserViewmodel with ChangeNotifier implements AuthBase {
  UserViewmodel() {
    currentUser();
  }
  Repository repository = locator<Repository>();
  ViewState _state = ViewState.busy;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  ViewState get state => _state;
  set state(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      state = ViewState.busy;
      _userModel = await repository.currentUser();
      return _userModel;
    } catch (e) {
      debugPrint(
        "currentt user hatasi viewmodel $e",
      );
      return null;
    } finally {
      state = ViewState.idly;
    }
  }

  @override
  Future<UserModel?> singInAnonymously() async {
    try {
      state = ViewState.busy;
      _userModel = await repository.singInAnonymously();
      return _userModel;
    } catch (e) {
      debugPrint("singInAnonymously hatası viewmodel$e");
      return null;
    } finally {
      state = ViewState.idly;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      state = ViewState.busy;
      bool sonuc = await repository.singOut();
      _userModel = null;
      return sonuc;
    } catch (e) {
      debugPrint(
        "singOuthatasi viewmodel$e",
      );
      return false;
    } finally {
      state = ViewState.idly;
    }
  }

  @override
  Future<UserModel?> googleWithSingIn() async {
    try {
      state = ViewState.busy;
      _userModel = await repository.googleWithSingIn();
      return _userModel;
    } catch (e) {
      debugPrint("singInAnonymously hatası viewmodel$e");
      return null;
    } finally {
      state = ViewState.idly;
    }
  }

  @override
  Future<UserModel?> createUserWithSingIn(String email, String password) async {
    try {
      state = ViewState.busy;
      _userModel = await repository.createUserWithSingIn(email, password);
      return _userModel;
    } finally {
      state = ViewState.idly;
    }
  }

  @override
  Future<UserModel?> emailAndPasswordWithSingIn(
      String email, String password) async {
    try {
      state = ViewState.busy;
      _userModel = await repository.emailAndPasswordWithSingIn(email, password);
      return _userModel;
    } finally {
      state = ViewState.idly;
    }
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    var result = await repository.updateUserName(userId, newUserName);
    if (result) {
      userModel!.userName = newUserName;
    }
    return result;
  }

  Future<String> uploadFile(
      String userId, String fileType, File? profilePhoto) async {
    var indirmeLink =
        await repository.uploadFile(userId, fileType, profilePhoto);
    return indirmeLink;
  }

  Stream<List<MesajModel>> getMessagers(
      String currentUserId, String sohbetEdilenUserId) {
    return repository.getMessagers(currentUserId, sohbetEdilenUserId);
  }

  Future<bool> saveMessages(MesajModel kaydedilecekMesaj) async {
    return await repository.saveMessages(kaydedilecekMesaj);
  }

  Future<List<KonusmaModel>> getAllConversations(String userId) async {
    return await repository.getAllConversations(userId);
  }

  Future<List<UserModel>> getUserWithPagination(
      UserModel? ensonGetirilenUser, int getirilecekElemanSayisi) async {
    return await repository.getUserWithPagination(
        ensonGetirilenUser, getirilecekElemanSayisi);
  }

  Future<bool> chatDelete(String currentUserId, String sohbetEdilenUserId) async {
    return repository.chatDelete( currentUserId,  sohbetEdilenUserId);
  }
}
