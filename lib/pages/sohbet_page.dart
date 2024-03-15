import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/google_ads.dart';
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/konusma_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class SohbetPage extends StatefulWidget {
  const SohbetPage({super.key});

  @override
  State<SohbetPage> createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  @override
  void initState() {
       locator.get<GoogleAds>().loadRewardAd();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbetler"),
      ),
      body: FutureBuilder<List<KonusmaModel>>(
        future: _userModel.getAllConversations(_userModel.userModel!.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var allTalks = snapshot.data!;

            if (allTalks.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () {
                  return refleshChat();
                },
                child: ListView.builder(
                  itemCount: allTalks.length,
                  itemBuilder: (context, index) {
                    var oankiTalk = allTalks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => KonusmaPage(
                              currentUser: _userModel.userModel!,
                              sohbetEdilenUser: UserModel.withIdAndProfileUrl(
                                  userId: oankiTalk.kimle_konusuyor,
                                  profilUrl: oankiTalk.konusulanUserProfilUrl),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(oankiTalk.son_yollanan_mesaj),
                        subtitle: Text(
                          oankiTalk.konusulanUserName.toString(),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(20),
                          backgroundImage: NetworkImage(
                            oankiTalk.konusulanUserProfilUrl.toString(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  refleshChat();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: const Center(
                      child: Text(
                        "Sohber bulunamadı!",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
/* 
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
  } */

  Future<Null> refleshChat() async {
    setState(
      () {
        Future.delayed(
          const Duration(seconds: 1),
        );
      },
    );
    return null;
  }
}
