// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import 'package:flutter_firebase_crashlytics_usage/model/tab_item.dart';

class CustomNavigationBar extends StatefulWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelecetedTab;
  final Map<TabItem, Widget> createPage;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CustomNavigationBar({
    Key? key,
    required this.currentTab,
    required this.onSelecetedTab,
    required this.createPage,
    required this.navigatorKeys,

  }) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, index) {
        var comeItem = TabItem.values[index];
        return CupertinoTabView( 
          navigatorKey: widget.navigatorKeys[comeItem],
            builder: (context) => widget.createPage[comeItem]!);
      },
      tabBar: CupertinoTabBar(
        items: [
          navBarItem(TabItem.Kullanicilar),
          navBarItem(TabItem.Profil),
        ],
        onTap: (index) => widget.onSelecetedTab(
          TabItem.values[index],
        ),
      ),
    );
  }

  BottomNavigationBarItem navBarItem(TabItem tabItem) {
    final createTab = TabItemData.allPerson[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(createTab!.icon), label: createTab.label);
  }
}
