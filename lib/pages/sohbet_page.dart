import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class SohbetPage extends StatefulWidget {
  const SohbetPage({super.key});

  @override
  State<SohbetPage> createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbetler"),
      ),
      body: FutureBuilder<List<KonusmaModel>>(
        future: _userModel.getAllConversations(_userModel.userModel!.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var allTalks = snapshot.data!;
            return ListView.builder(
              itemCount: allTalks.length,
              itemBuilder: (context, index) {
                var oankiTalk = allTalks[index];
                return ListTile(
                  title: Text(oankiTalk.son_yollanan_mesaj),
                  subtitle: Text(
                    oankiTalk.konusulanUserName.toString(),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      oankiTalk.konusulanUserProfilUrl.toString(),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> konusmalariGetir() async {
    final _userModel = Provider.of<UserViewmodel>(context);
    var konusmalarigetir = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.userModel!.userId)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();
    for (var konusma in konusmalarigetir.docs) {
      print("konusma" + konusma.data().toString());
    }
  }
}
