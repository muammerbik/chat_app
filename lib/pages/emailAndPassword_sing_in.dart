import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/platform_widgets/platform_responsive_alert_dialog.dart';
import 'package:flutter_firebase_crashlytics_usage/errors.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
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
    butonText = myUserType == UserType.login ? "Giriş yap" : " Kayıt ol";
    linkText = myUserType == UserType.login ? "Kayıt ol" : "Giriş yap ";

    final userViewmodel = Provider.of<UserViewmodel>(context);

    if (userViewmodel.userModel != null) {
      Future.delayed(
        Duration(microseconds: 10),
        () {
          Navigator.of(context).pop();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Email ve şifre ile giriş!"),
      ),
      body: userViewmodel.state == ViewState.idly
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (newValue) {
                          email = newValue!;
                        },
                        autofocus: true,
                        initialValue: "mamercan@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "E mail",
                          labelText: "E mail girini!",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                        obscureText: true,
                        initialValue: "123123112",
                        decoration: InputDecoration(
                          hintText: "Şifre",
                          labelText: "Şifre girini!",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomSingInButton(
                        color: Colors.purple,
                        text: butonText,
                        iconWidget: SizedBox(width: 95),
                        onTop: () {
                          onSubmitSingIn();
                        },
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 30),
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
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void onSubmitSingIn() async {
    formKey.currentState!.save();
    final usermodel = Provider.of<UserViewmodel>(context, listen: false);
    if (myUserType == UserType.login) {
      try {
        UserModel? loginUser =
            await usermodel.emailAndPasswordWithSingIn(email, password);
        if (loginUser != null)
          print(
            " oturum açan user id" + loginUser.userId.toString(),
          );
      } on FirebaseAuthException catch (e) {
        debugPrint(
            "widget  oturum ama hata yakalandı " + Errors.showError(e.code));
        PlatformResponsiveAlertDialog(
          title: "Kullanıcı giriş hatası !",
          contents: "Bu kullanıcı db de mevcut değil",
          okButonText: "Tamam",
        ).showAllDialog(context);
      }
    } else {
      try {
        UserModel? createUser =
            await usermodel.createUserWithSingIn(email, password);
        if (createUser != null)
          print(
            " kayıt olan user id" + createUser.userId.toString(),
          );
      } on FirebaseAuthException catch (e) {
        debugPrint("widget kulllanici  oluşturma hata yakalandi" +
            Errors.showError(e.code));
        PlatformResponsiveAlertDialog(
          title: "Oturum açma  hatası!",
          contents: "Bu Email zaten kullanılıyor! farklı birşey deneyin!",
          okButonText: "Tamam",
        ).showAllDialog(context);
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
