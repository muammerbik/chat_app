import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/buttons/custom_sing_in_button.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/emailAndPassword_sing_in.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
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
      appBar: AppBar(
        title: Text("Messaging App"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Text(
            "Sing-in",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          CustomSingInButton(
            text: "Google Sing-in",
            color: Colors.white,
            onTop: () {
              signInWithGoogle(context);
            },
            iconWidget: Image.asset(
              "assets/images/google.png",
              fit: BoxFit.contain,
              width: 40,
            ),
          ),
          SizedBox(height: 15),
          CustomSingInButton(
            textColor: Colors.white,
            text: "Facebook Sing-in",
            onTop: () {},
            color: Color(0xff3b5997),
            iconWidget: Image.asset(
              "assets/images/facebook.png",
              fit: BoxFit.contain,
              width: 40,
            ),
          ),
          SizedBox(height: 15),
          CustomSingInButton(
            text: "E mail Sing-in",
            onTop: () {
              emailAndPasswordWithSingIn(context);
            },
            color: Colors.white,
            iconWidget: Image.asset(
              "assets/images/gmail.png",
              fit: BoxFit.contain,
              width: 40,
            ),
          ),
          SizedBox(height: 15),
          CustomSingInButton(
            text: "guest sign-in",
            onTop: () {
              singInGuest(context);
            },
            color: Colors.white,
            iconWidget: Image.asset(
              "assets/images/user.png",
              fit: BoxFit.contain,
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
