import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/service/advertising/google_ads.dart';
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
    final userModel = Provider.of<UserViewmodel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(chats),
      ),
      body: FutureBuilder<List<KonusmaModel>>(
        future: userModel.getAllConversations(userModel.userModel!.userId),
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
                              currentUser: userModel.userModel!,
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
                              const Icon(
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
                          bool sonuc = await userModel.chatDelete(
                            userModel.userModel!.userId,
                            oankiTalk.kimle_konusuyor,
                          );
                          if (sonuc) {
                            allTalks.removeAt(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: lightIndigo,
                                content: Text(
                                  chatDelete,
                                  style: TextStyle(color: black, fontSize: 16),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: lightIndigo,
                                content: Text(
                                  chaNotDelete,
                                  style: TextStyle(color: black, fontSize: 16),
                                ),
                              ),
                            );
                          }
                        },
                        key: UniqueKey(),
                        child: Card(
                          child: Container(
                            color: white,
                            child: ListTile(
                              title: Text(
                                formatMessage(
                                  oankiTalk.konusulanUserName.toString(),
                                ),
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
                                style: TextStyle(fontSize: 13.sp),
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
                  child: SizedBox(
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

  Future<void> refleshChat() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
    return;
  }

  String formatMessage(String message) {
    if (message.length > 15) {
      return '${message.substring(0, 15)}...';
    } else {
      return message;
    }
  }
}
