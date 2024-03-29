// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/constants.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class KonusmaPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel sohbetEdilenUser;
  const KonusmaPage({
    required this.currentUser,
    required this.sohbetEdilenUser,
  });

  @override
  State<KonusmaPage> createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userModel = Provider.of<UserViewmodel>(context);
    UserModel _currentUser = widget.currentUser;
    UserModel _sohbetEdilenUser = widget.sohbetEdilenUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.sohbetEdilenUser.profilUrl! ?? ""),
                backgroundColor: grey.shade100),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, right: 16),
                child: Text(
                  widget.sohbetEdilenUser.userName ?? 'Bilinmeyen Kullanıcı',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MesajModel>>(
                stream: _userModel.getMessagers(
                    _currentUser.userId, _sohbetEdilenUser.userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<MesajModel> tumMessajlar = snapshot.data!;

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: tumMessajlar.length,
                    itemBuilder: (context, index) {
                      return konusmaBalonlari(
                          tumMessajlar[tumMessajlar.length - 1 - index]);
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20.h, left: 12.w, top: 15.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: textEditingController,
                      cursorColor: black,
                      style: TextStyle(fontSize: 18.sp, color: black),
                      decoration: InputDecoration(
                        fillColor: grey.shade100,
                        filled: true,
                        hintText: enterMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide:
                              BorderSide(color: lightIndigo, width: 2.w),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: indigo,
                      child: const Icon(
                        Icons.navigation,
                        size: 35,
                        color: white,
                      ), //Butona tıklandığında stream yapısıyla beraber ekranda  yazılacak mesajları kaydediyorum.
                      onPressed: () async {
                        if (textEditingController.text.trim().isNotEmpty) {
                          MesajModel kaydedilecekMesaj = MesajModel(
                              kimden: _currentUser.userId,
                              kime: _sohbetEdilenUser.userId,
                              bendenMi: true,
                              mesaj: textEditingController.text);

                          var result =
                              await _userModel.saveMessages(kaydedilecekMesaj);
                          if (result) {
                            textEditingController.clear();
                            _scrollController.animateTo(
                              0, // ListView'in en altına kaydır
                              duration: Duration(milliseconds: 10),
                              curve: Curves.easeOut,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget konusmaBalonlari(MesajModel oankiMesaj) {
    Color messageSender = purple;
    Color messageField = indigo;
    var fromMe = oankiMesaj.bendenMi;

    var timeAndMinuteValue = "";
    try {
      timeAndMinuteValue =
          showTimeAndMinute(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("mesaj gönderimde zaman hatası var " + e.toString());
    }

    if (fromMe) {
      return Padding(
        padding: EdgeInsets.only(
          left: 45.w,
          top: 10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: messageSender,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Text(
                        oankiMesaj.mesaj,
                        style: TextStyle(fontSize: 17.sp, color: white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(timeAndMinuteValue),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: grey.shade200,
                  backgroundImage:
                      NetworkImage(widget.sohbetEdilenUser.profilUrl!),
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: messageField,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        oankiMesaj.mesaj,
                        style: TextStyle(fontSize: 17.sp, color: white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(timeAndMinuteValue),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  String showTimeAndMinute(Timestamp? date) {
    var _formatter = DateFormat.Hm();
    var formatlanmisTarih = _formatter.format(date!.toDate());
    return formatlanmisTarih;
  }
}
