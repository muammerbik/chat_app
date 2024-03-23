import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/constants.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/emailAndPassword_sing_in.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SingInScreenView extends StatelessWidget {
  Future<void> singInGuest(BuildContext context) async {
    final userViewmodel = Provider.of<UserViewmodel>(context, listen: false);
    var userCredential = await userViewmodel.singInAnonymously();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final userViewmodel = Provider.of<UserViewmodel>(context, listen: false);
    var userCredential = await userViewmodel.googleWithSingIn();
  }

  void emailAndPasswordWithSingIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const EmailAndPassworWithSingIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: AppBar(
        title: Text(appName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60.h),
          Text(
            singIn,
            style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40.h),
          CustomSingInButton(
            text: googlSsingIn,
            color: white,
            onTop: () {
              signInWithGoogle(context);
            },
            iconWidget: Image.asset(
              "assets/images/google.png",
              fit: BoxFit.contain,
              width: 40.w,
            ),
          ),
          SizedBox(height: 18.h),
          CustomSingInButton(
            textColor: white,
            text: faceSingIn,
            onTop: () {},
            color: facebookColor,
            iconWidget: Image.asset(
              "assets/images/facebook.png",
              fit: BoxFit.contain,
              width: 40.w,
            ),
          ),
          SizedBox(height: 18.h),
          CustomSingInButton(
            text: emailSingIn,
            onTop: () {
              emailAndPasswordWithSingIn(context);
            },
            color: white,
            iconWidget: Image.asset(
              "assets/images/gmail.png",
              fit: BoxFit.contain,
              width: 40.w,
            ),
          ),
          SizedBox(height: 18.h),
          CustomSingInButton(
            text: guestSingIn,
            onTop: () {
              singInGuest(context);
            },
            color: white,
            iconWidget: Image.asset(
              "assets/images/user.png",
              fit: BoxFit.contain,
              width: 40.w,
            ),
          ),
        ],
      ),
    );
  }
}
