// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_navigation_bar.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/model/tab_item.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/profile_page.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/users_page.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/auth_base.dart';
import 'package:flutter_firebase_crashlytics_usage/service/auth_service/firebase_auth_service.dart';

class HomePage extends StatefulWidget {
  final UserModel? user;

  const HomePage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthBase firebaseAuthService = locator<FirebaseAuthService>();
  TabItem currentTabItem = TabItem.Kullanicilar;

  Map<TabItem, Widget> allUsers() {
    return {
      TabItem.Kullanicilar: UsersPage(),
      TabItem.Profil: ProfilePage(),
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKey = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKey[currentTabItem]!.currentState!.maybePop(),
      child: Center(
        child: CustomNavigationBar(
          navigatorKeys: navigatorKey,
          createPage: allUsers(),
          currentTab: currentTabItem,
          onSelecetedTab: (value) {
            if (value == currentTabItem) {
              navigatorKey[value]!
                  .currentState!
                  .popUntil((route) => route.isFirst);
            } else {
              setState(() {
                currentTabItem = value;
              });
              print("seçilen tab " + value.toString());
            }
          },
        ),
      ),
    );
  }
}
