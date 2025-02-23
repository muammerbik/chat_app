import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_elevated_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/navigation_helper/navigation_halper.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/emailAndPassword_sing_in.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/sign_in/view/sign_in_page.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/sign_up/view/sign_up_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({super.key});

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              "assets/images/messaging.png",
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Arkadaşlarınla güvenli ve\nhızlı bir şekilde sohbet et!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Mesajlaşmanın en kolay yolu",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.sp,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: CustomElevatedButtonView(
                text: "Giriş Yap",
                color: customRed,
                textColor: Colors.white,
                onTop: () {
                  /*  Navigation.push(page: SignInPage()); */
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: CustomElevatedButtonView(
                text: "Hesap Oluştur",
                color: Colors.white,
                textColor: customRed,
                borderColor: customRed,
                onTop: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ));
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}




   /*  Align(
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
          ), */
       