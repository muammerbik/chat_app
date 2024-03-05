import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/repository/repository.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  Repository repository = locator<Repository>();
  AllUserViewState _state = AllUserViewState.Idle;

  AllUserViewState get state => _state;

  bool get hasMoreLoading => _hasMore;

  set state(AllUserViewState newState) {
    _state = newState;
    notifyListeners();
  }

  List<UserModel> _allPersonList = [];
  List<UserModel> get tumKullanicilerListesi => _allPersonList;
  bool _hasMore = true;
  UserModel? _ensonGetirilenUser;
  static final sayfaBasinaGonderi = 9;

  AllUserViewModel() {
    _allPersonList = [];
    _ensonGetirilenUser = null;
    getUserWithPagination(_ensonGetirilenUser, false);
  }
  getUserWithPagination(
      UserModel? ensonGetirilenUser, bool yeniElemanGetiriliyor) async {
    if (_allPersonList.isNotEmpty) {
      _ensonGetirilenUser = _allPersonList.last;
    }

    if (!yeniElemanGetiriliyor) {
      state = AllUserViewState.Busy;
    }
    var yeniListe = await repository.getUserWithPagination(
        _ensonGetirilenUser, sayfaBasinaGonderi);

    // Yeni gelen listeyi var olan listeye eklerken benzersizliği kontrol et
    var eklenecekListe = yeniListe
        .where((yeniUser) => !_allPersonList
            .any((mevcutUser) => mevcutUser.userId == yeniUser.userId))
        .toList();

    if (eklenecekListe.isNotEmpty) {
      _allPersonList.addAll(eklenecekListe);
      // Eğer yeni listeyi başarıyla eklediysek ve bu liste beklediğimiz sayıda değilse, daha fazla veri kalmadı demektir.
      _hasMore = eklenecekListe.length == sayfaBasinaGonderi;
    } else {
      // Yeni eklenecek bir şey yoksa, daha fazla veri kalmadığını varsayabiliriz.
      _hasMore = false;
    }
   
    state = AllUserViewState.Loaded;
    
  }

  Future<void> dahaFazlaGetir() async {
    if (_hasMore) {
      getUserWithPagination(_ensonGetirilenUser, true);
    } else {
      await Future.delayed(
        Duration(seconds: 2),
      );
    }
  }

  Future<Null> refreshIndicator() async {
    _hasMore = true;
    _ensonGetirilenUser = null;
    _allPersonList = [];
    getUserWithPagination(_ensonGetirilenUser, true);
  }
}
