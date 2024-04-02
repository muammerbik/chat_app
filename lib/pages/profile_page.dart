import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/platform_widgets/platform_responsive_alert_dialog.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/constants.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/service/advertising/google_ads.dart';
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
    UserViewmodel userModel = Provider.of<UserViewmodel>(context);
    textEditingController.text = userModel.userModel!.userName!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(profil),
        actions: [
          TextButton(
            onPressed: () {
              requestConfirmationExit(context);
            },
            child: const Text(exit),
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
                      return SizedBox(
                        height: 200.h,
                        child: Column(
                          children: [
                            ListTile(
                                title: const Text(takePicture),
                                leading: const Icon(Icons.camera),
                                onTap: () {
                                  imageFromCamera();
                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                              title: const Text(selectFromGallery),
                              leading: const Icon(Icons.image),
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
                          ? NetworkImage(userModel.userModel!.profilUrl!)
                          : FileImage(profilePhoto!) as ImageProvider,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextFormField(
                  initialValue: userModel.userModel!.email,
                  readOnly: true,
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
    final result = await const PlatformResponsiveAlertDialog(
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
    UserViewmodel userModel =
        Provider.of<UserViewmodel>(context, listen: false);
    if (userModel.userModel!.userName != textEditingController.text) {
      var updateResult = await userModel.updateUserName(
          userModel.userModel!.userId, textEditingController.text);

      if (updateResult) {
        const PlatformResponsiveAlertDialog(
                title: successfulTransaction,
                contents: changesSaved,
                okButonText: ok)
            .showAllDialog(context);
      } else {
        textEditingController.text == userModel.userModel!.userName;
        const PlatformResponsiveAlertDialog(
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
    UserViewmodel userModel =
        Provider.of<UserViewmodel>(context, listen: false);
    if (profilePhoto != null) {
      var url = await userModel.uploadFile(
          userModel.userModel!.userId, "profil_photo", profilePhoto);
      debugPrint("gelen url = $url");
      const PlatformResponsiveAlertDialog(
              title: profilephoto,
              contents: profilePhotoContent,
              okButonText: ok)
          .showAllDialog(context);
    }
  }
}
