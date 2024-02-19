// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Profil }

class TabItemData {
  final String label;
  final IconData icon;

  TabItemData(
    this.label,
    this.icon,
  );

 static Map<TabItem, TabItemData> allPerson = {
    TabItem.Kullanicilar: TabItemData(
      "Kullanıcılar",
      Icons.supervisor_account_outlined,
    ),
    TabItem.Profil: TabItemData(
      "Profil",
      Icons.person_outlined,
    ),
  };
}
