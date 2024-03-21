import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/platform_widgets/platform_responsive_alert_dialog.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/google_ads.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  TextEditingController textEditingController = TextEditingController();
  File? profilePhoto;
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    locator.get<GoogleAds>().loadInterstitialAd();
    locator.get<GoogleAds>().loadBannerAd();

    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    locator.get<GoogleAds>().interstitialAd!.dispose();
    locator.get<GoogleAds>().bannerAd!.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userModel = Provider.of<UserViewmodel>(context);
    textEditingController.text = _userModel.userModel!.userName!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile "),
        actions: [
          TextButton(
            onPressed: () {
              requestConfirmationExit(context);
            },
            child: Text("exit"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 170,
                        child: Column(
                          children: [
                            ListTile(
                                title: Text("Camera aç"),
                                leading: Icon(Icons.camera),
                                onTap: () {
                                  imageFromCamera();
                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                              title: Text("Galeri ye git"),
                              leading: Icon(Icons.image),
                              onTap: () {
                                imageFromGallery();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.indigo,
                  backgroundImage: profilePhoto == null
                      ? NetworkImage(_userModel.userModel!.profilUrl!)
                      : FileImage(profilePhoto!) as ImageProvider,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: _userModel.userModel!.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "E mail giriniz!",
                    hintText: "e mail",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: "Username giriniz!",
                    hintText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              CustomSingInButton(
                  text: "Değişiklikleri kaydet",
                  textColor: Colors.white,
                  onTop: () {
                    locator.get<GoogleAds>().showInterstitialAd();
                    updateUserName(context);
                    profilePhotoGuncelle(context);
                  },
                  color: Colors.purple),
              if (locator.get<GoogleAds>().bannerAd != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 320,
                    height: 50,
                    child: AdWidget(ad: locator.get<GoogleAds>().bannerAd!),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> singOutFunc(BuildContext context) async {
    final userViewmodel = Provider.of<UserViewmodel>(context, listen: false);
    bool result = await userViewmodel.singOut();
    return result;
  }

  Future requestConfirmationExit(BuildContext context) async {
    final result = await PlatformResponsiveAlertDialog(
      title: "Emin isiniz ?",
      contents: "Çıkış işlemi yapmak istediğinize eminmisiniz?",
      okButonText: "evet",
      cancelButonText: "vazgeç",
    ).showAllDialog(context);
    if (result == true) {
      singOutFunc(context);
    }
  }

  void updateUserName(BuildContext context) async {
    UserViewmodel _userModel =
        Provider.of<UserViewmodel>(context, listen: false);
    if (_userModel.userModel!.userName != textEditingController.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.userModel!.userId, textEditingController.text);

      if (updateResult) {
        PlatformResponsiveAlertDialog(
          title: "Başarılı işlem",
          contents: "Değişiklikler kaydedildi",
          okButonText: "Tamam",
        ).showAllDialog(context);
      } else {
        textEditingController.text == _userModel.userModel!.userName;
        PlatformResponsiveAlertDialog(
          title: "User name hatası",
          contents: "UserName zaten kullanımda var, farklı user name deneyin!",
          okButonText: "Tamam",
        ).showAllDialog(context);
      }
    }
  }

  void imageFromCamera() async {
    var cameraPhoto = await picker.pickImage(source: ImageSource.camera);
    if (cameraPhoto != null) {
      setState(() {
        profilePhoto = File(cameraPhoto.path); // XFile'dan File'a dönüştürme
      });
    }
  }

  void imageFromGallery() async {
    var galleryPhoto = await picker.pickImage(source: ImageSource.gallery);
    if (galleryPhoto != null) {
      setState(() {
        profilePhoto = File(galleryPhoto.path); // XFile'dan File'a dönüştürme
      });
    }
  }

  Future<void> profilePhotoGuncelle(BuildContext context) async {
    UserViewmodel _userModel =
        Provider.of<UserViewmodel>(context, listen: false);
    if (profilePhoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.userModel!.userId, "profil_photo", profilePhoto);
      print("gelen url = " + url);
      if (url != null) {
        PlatformResponsiveAlertDialog(
          title: "Profil başarıyla yüklendi !",
          contents: "profil resmi işlemşeri tamamalandı.",
          okButonText: "Tamam",
        ).showAllDialog(context);
      }
    }
  }
}
