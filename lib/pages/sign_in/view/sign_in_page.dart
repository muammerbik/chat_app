import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_elevated_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/custom_textFormField/custom_textForm_Field.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/sign_up/view/sign_up_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> signInWithGoogle(BuildContext context) async {
    final userViewmodel = Provider.of<UserViewmodel>(context, listen: false);
    var userCredential = await userViewmodel.googleWithSingIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                "assets/images/online_message.png",
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 40.h),
              Text(
                "Hoş Geldiniz!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Hesabınıza giriş yapın",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 32.h),
              CustomTextFormField(
                controller: emailController,
                hintText: "E-mail giriniz",
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: passwordController,
                hintText: "Şifre giriniz",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Şifremi unuttum işlemi
                  },
                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomElevatedButtonView(
                text: "Giriş Yap",
                color: customRed,
                textColor: Colors.white,
                onTop: () {},
              ),
              SizedBox(height: 24.h),
              CustomSingInButton(
                iconWidget: Image.asset(
                  "assets/images/google.png",
                  fit: BoxFit.contain,
                  width: 24.w,
                ),
                text: "Google ile Giriş",
                onTop: () {
                  signInWithGoogle(context);
                },
                color: Colors.white,
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hesabın yok mu?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ));
                      },
                      child: Text(
                        "Kayıt ol",
                        style: TextStyle(
                          color: customRed,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
