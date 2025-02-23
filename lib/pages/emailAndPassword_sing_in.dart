import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/platform_widgets/platform_responsive_alert_dialog.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

enum UserType { register, login }

class EmailAndPassworWithSingIn extends StatefulWidget {
  const EmailAndPassworWithSingIn({super.key});

  @override
  State<EmailAndPassworWithSingIn> createState() =>
      _EmailAndPassworWithSingInState();
}

class _EmailAndPassworWithSingInState extends State<EmailAndPassworWithSingIn> {
  String email = "";
  String password = "";
  String butonText = "";
  String linkText = "";

  var myUserType = UserType.register;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    butonText = myUserType == UserType.login ? loginn : registerr;
    linkText = myUserType == UserType.login ? registerr : loginn;

    final userViewmodel = Provider.of<UserViewmodel>(context);
    if (userViewmodel.userModel != null) {
      Future.delayed(
        const Duration(milliseconds: 1),
        () {
          Navigator.of(context).popUntil(ModalRoute.withName("/"));
        },
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          emailPasswordSingIn,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: userViewmodel.state == ViewState.idly
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (newValue) {
                          email = newValue!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-mail cannot be empty! and enter valid email';
                          }
                          return null;
                        },
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: emailText,
                          labelText: enterEmail,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'password cannot be empty!';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: passwordText,
                          labelText: enterPassword,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomSingInButton(
                        color: purple,
                        text: butonText,
                        iconWidget: SizedBox(width: 95.w),
                        onTop: () {
                          onSubmitSingIn();
                        },
                        textColor: white,
                      ),
                      SizedBox(height: 25.h),
                      TextButton(
                        onPressed: () {
                          degistirFunc();
                        },
                        child: Text(linkText),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void onSubmitSingIn() async {
    formKey.currentState!.validate();
    formKey.currentState!.save();
    final usermodel = Provider.of<UserViewmodel>(context, listen: false);
    if (email.isEmpty && password.isEmpty) {
      return null;
    } else {
      if (myUserType == UserType.login) {
        try {
          UserModel? loginUser =
              await usermodel.emailAndPasswordWithSingIn(email, password);
          if (loginUser != null) {
            debugPrint(
              " oturum açan user id${loginUser.userId}",
            );
          }
        } on FirebaseAuthException {
          debugPrint("widget  oturum açmada hata yakalandı ");
          const PlatformResponsiveAlertDialog(
            title: userLoginEror,
            contents: registerContenterrorText,
            okButonText: ok,
          ).showAllDialog(context);
        }
      } else {
        try {
          UserModel? createUser =
              await usermodel.createUserWithSingIn(email, password);
          if (createUser != null) {
            debugPrint(
              " kayıt olan user id${createUser.userId}",
            );
          }
        } on FirebaseAuthException {
          debugPrint("widget kulllanici  oluşturma hata yakalandi");
          const PlatformResponsiveAlertDialog(
            title: loginError,
            contents: loginContentError,
            okButonText: ok,
          ).showAllDialog(context);
        }
      }
    }
  }

  void degistirFunc() {
    setState(
      () {
        myUserType =
            myUserType == UserType.login ? UserType.register : UserType.login;
      },
    );
  }
}
