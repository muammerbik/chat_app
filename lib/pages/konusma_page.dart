// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/model/mesaj_model.dart';

import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userModel = Provider.of<UserViewmodel>(context);
    UserModel currentUser = widget.currentUser;
    UserModel sohbetEdilenUser = widget.sohbetEdilenUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MesajModel>>(
                stream: _userModel.getMessagers(
                    currentUser.userId, sohbetEdilenUser.userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<MesajModel> tumMessajlar = snapshot.data!;
                  return ListView.builder(
                    itemCount: tumMessajlar.length,
                    itemBuilder: (context, index) {
                      return Text(tumMessajlar[index].mesaj);
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      cursorColor: Colors.blue,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Mesaj girin!",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ), //Butona tıklandığında stream yapısıyla beraber ekranda  yazılacak mesajları kaydediyorum.
                      onPressed: () async {
                        if (textEditingController.text.trim().length > 0) {
                          MesajModel kaydedilecekMesaj = MesajModel(
                              kimden: currentUser.userId,
                              kime: sohbetEdilenUser.userId,
                              bendenMi: true,
                              mesaj: textEditingController.text);

                          var result =
                             await _userModel.saveMessages(kaydedilecekMesaj);
                          if (result) {
                            textEditingController.clear();
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
}
