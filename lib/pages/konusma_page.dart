// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
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
              backgroundColor: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                widget.sohbetEdilenUser.userName ?? 'Bilinmeyen Kullanıcı',
                style: TextStyle(fontSize: 18),
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
              padding: const EdgeInsets.only(bottom: 18, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: textEditingController,
                      cursorColor: Colors.blue,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Mesaj girin!",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue.shade700,
                      child: const Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
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
    Color messageSender = Colors.purple;
    Color messageField = Colors.indigo;
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
        padding: const EdgeInsets.all(8.0),
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        oankiMesaj.mesaj,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(timeAndMinuteValue),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        oankiMesaj.mesaj,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
