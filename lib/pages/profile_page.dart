import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/platform_widgets/platform_responsive_alert_dialog.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/constants.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/google_ads.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(profil),
        actions: [
          TextButton(
            onPressed: () {
              requestConfirmationExit(context);
            },
            child: Text(exit),
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
                        height: 170.h,
                        child: Column(
                          children: [
                            ListTile(
                                title: Text(takePicture),
                                leading: Icon(Icons.camera),
                                onTap: () {
                                  imageFromCamera();
                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                              title: Text(selectFromGallery),
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
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(82.r),
                      border: Border.all(color: Colors.black),
                    ),
                    child: CircleAvatar(
                      radius: 80.r,
                      backgroundColor: lightIndigo,
                      backgroundImage: profilePhoto == null
                          ? NetworkImage(_userModel.userModel!.profilUrl!)
                          : FileImage(profilePhoto!) as ImageProvider,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextFormField(
                  initialValue: _userModel.userModel!.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: enterEmail,
                    hintText: emailText,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: enterUsername,
                    hintText: titleUsername,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              CustomSingInButton(
                  text: saveText,
                  iconWidget: SizedBox(width: 120.w),
                  textColor: white,
                  onTop: () {
                    locator.get<GoogleAds>().showInterstitialAd();
                    updateUserName(context);
                    profilePhotoGuncelle(context);
                  },
                  color: purple),
              if (locator.get<GoogleAds>().bannerAd != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: SizedBox(
                    width: 380.w,
                    height: 70.h,
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
      title: logOut,
      contents: logOutContent,
      okButonText: yes,
      cancelButonText: no,
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
                title: successfulTransaction,
                contents: changesSaved,
                okButonText: ok)
            .showAllDialog(context);
      } else {
        textEditingController.text == _userModel.userModel!.userName;
        PlatformResponsiveAlertDialog(
                title: userLoginEror,
                contents: usernameContentError,
                okButonText: ok)
            .showAllDialog(context);
      }
    }
  }

  void imageFromCamera() async {
    var cameraPhoto = await picker.pickImage(source: ImageSource.camera);
    if (cameraPhoto != null) {
      setState(() {
        profilePhoto = File(cameraPhoto.path);
      });
    }
  }

  void imageFromGallery() async {
    var galleryPhoto = await picker.pickImage(source: ImageSource.gallery);
    if (galleryPhoto != null) {
      setState(() {
        profilePhoto = File(galleryPhoto.path);
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
                title: profilephoto,
                contents: profilePhotoContent,
                okButonText: ok)
            .showAllDialog(context);
      }
    }
  }
}
