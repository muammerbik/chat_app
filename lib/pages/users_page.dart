import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/konusma_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
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
              return RefreshIndicator(
                onRefresh: () {
                  return refleshPerson();
                },
                child: ListView.builder(
                  itemCount: tumKullanicilar.length,
                  itemBuilder: (context, index) {
                    var oankiKullanici = snapshot.data![index];
                    // fireStordaki tüm kullanıcılar geldi, tüm kullanıclar arasında kullanıcı kendiyle konuşamayacağı
                    //için kullanıcının kendisini gelen tüm kullanıcılar arasından çıkarttım.
                    if (oankiKullanici.userId != _userModel.userModel!.userId) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => KonusmaPage(
                                  sohbetEdilenUser: oankiKullanici,
                                  currentUser: _userModel.userModel!),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(oankiKullanici.userName!),
                          subtitle: Text(oankiKullanici.email),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.withAlpha(20),
                              backgroundImage:
                                  NetworkImage(oankiKullanici.profilUrl!)),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  refleshPerson();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Center(
                      child: Text(
                        "Kayıtlı kullanıcı bulunamadı!",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
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

  Future<Null> refleshPerson() async {
    // uygulama kullanırken yeni kullanıcı eklemesş ya da mesajın gelip gelmemdiğini kontrol etmek için refleshIndıcator kullandım. setState kullanmamın amacı buildi tekrar tetiklemesidir.
    setState(
      () {
        Future.delayed(
          Duration(seconds: 1),
        );
      },
    );
    return null;
  }
}
