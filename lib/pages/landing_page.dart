import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/home_page.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/sing_in_view.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewmodel = Provider.of<UserViewmodel>(context);
    
    if (userViewmodel.state == ViewState.idly) {
      if (userViewmodel.userModel == null) {
        return const SingInScreenView();
      } else {
        return HomePage(user: userViewmodel.userModel,);
      }
    } else {
      return const Scaffold(
           resizeToAvoidBottomInset: false,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
