import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/emailAndPassword_sing_in.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SingInScreenView extends StatelessWidget {
  const SingInScreenView({super.key});

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 150.h),
          const Text(
            appName,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 50.h),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: grey.shade50,
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: black.withOpacity(0.5), width: 2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      singIn,
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),
                    SizedBox(height: 25.h),
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
                    SizedBox(height: 20.h),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
