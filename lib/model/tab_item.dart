// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/constants.dart';

enum TabItem { Kullanicilar, Sohbet, Profil }

class TabItemData {
  final String label;
  final IconData icon;

  TabItemData(
    this.label,
    this.icon,
  );

  static Map<TabItem, TabItemData> allPerson = {
    TabItem.Kullanicilar: TabItemData(
      users,
      Icons.supervisor_account_outlined,
    ),
    TabItem.Sohbet: TabItemData(chats, Icons.chat),
    TabItem.Profil: TabItemData(
      profil,
      Icons.person_outlined,
    ),
  };
}
