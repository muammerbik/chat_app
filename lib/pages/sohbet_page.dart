import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/constants.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/google_ads.dart';
import 'package:flutter_firebase_crashlytics_usage/model/konusma_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/konusma_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    locator.get<GoogleAds>().rewardedAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewmodel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(chats),
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
                                  userName: oankiTalk.konusulanUserName,
                                  userId: oankiTalk.kimle_konusuyor,
                                  profilUrl: oankiTalk.konusulanUserProfilUrl),
                            ),
                          ),
                        );
                      },
                      child: Dismissible(
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: red,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.delete,
                                color: white,
                                size: 35,
                              ),
                              Text(
                                delete,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) async {
                          bool sonuc = await _userModel.chatDelete(
                              _userModel.userModel!.userId,
                              oankiTalk.kimle_konusuyor);
                          if (sonuc) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor:
                                    Color.fromARGB(255, 9, 108, 142),
                                content: Text(chatDelete)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(chaNotDelete)));
                          }
                        },
                        key: UniqueKey(),
                        child: Card(
                          child: Container(
                            color: white,
                            child: ListTile(
                              title: Text(
                                oankiTalk.konusulanUserName.toString(),
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                formatMessage(
                                    oankiTalk.son_yollanan_mesaj.toString()),
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              trailing: Text(
                                oankiTalk.saat_farki.toString(),
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: grey.withAlpha(30),
                                backgroundImage: NetworkImage(
                                  oankiTalk.konusulanUserProfilUrl.toString(),
                                ),
                              ),
                            ),
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
                    height: MediaQuery.of(context).size.height - 150.h,
                    child: Center(
                      child: Text(
                        noChatFound,
                        style: TextStyle(fontSize: 20.sp),
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

  String formatMessage(String message) {
    if (message.length > 15) {
      return '${message.substring(0, 15)}...';
    } else {
      return message;
    }
  }
}
