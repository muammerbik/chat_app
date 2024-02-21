import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userModel = Provider.of<UserViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("KULLANICILAR SAYAFASI"),
      ),
      body: FutureBuilder(
        future: _userModel.getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var tumKullanicilar = snapshot.data!;
            if (tumKullanicilar.length - 1 > 0) {
              return ListView.builder(
                itemCount: tumKullanicilar.length,
                itemBuilder: (context, index) {
                  var oankiKullanici = snapshot.data![index];
// fireStordaki tüm kullanıcılar geldi, tüm kullanıclar arasında kullanıcı kendiyle konuşamayacağı için kullanıcının kendisini gelen tüm kullanıcılar arasından çıkarttım.
                  if (oankiKullanici.userId != _userModel.userModel!.userId) {
                    return ListTile(
                      title: Text(oankiKullanici.userName!),
                      subtitle: Text(oankiKullanici.email),
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(oankiKullanici.profilUrl!)),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return Center(
                child: Text("Kayıtlı kullanıcı bulunamdı !"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
