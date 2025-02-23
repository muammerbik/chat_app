import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_elevated_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/custom_textFormField/custom_textForm_Field.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
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
              const Spacer(flex: 1),
              Image.asset(
                "assets/images/sign_up.png",
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 32.h),
              Text(
                "Hesap Oluştur",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Hemen kayıt ol ve mesajlaşmaya başla!",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 32.h),
              CustomTextFormField(
                controller: nameController,
                hintText: "İsim giriniz",
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: surnameController,
                hintText: "Soyisim giriniz",
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: emailController,
                hintText: "Email giriniz",
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: passwordController,
                hintText: "Şifre giriniz",
              ),
              SizedBox(height: 24.h),
              CustomElevatedButtonView(
                text: "Hesap Oluştur",
                color: customRed,
                textColor: Colors.white,
                onTop: () {
                  // Hesap oluşturma işlemi
                },
              ),
              SizedBox(height: 16.h),
              CustomSingInButton(
                iconWidget: Image.asset(
                  "assets/images/google.png",
                  fit: BoxFit.contain,
                  width: 24.w,
                ),
                text: "Google ile Kayıt Ol",
                onTop: () {
                     signInWithGoogle(context);
                },
                color: Colors.white,
              ),
              const Spacer(flex: 1),
              Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hesabın var mı?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Giriş Yap",
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
