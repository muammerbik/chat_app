import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/konusma_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/all_user_viewmodel.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}
class _UsersPageState extends State<UsersPage> {
  bool _isLoading = false; //intarnetten veri geliyormuyu kontrol etsin.
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        listeScrollListener();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users "),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: RefreshIndicator(
                  onRefresh: () => model.refreshIndicator(),
                  child: CircularProgressIndicator()),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: () => model.refreshIndicator(),
              child: ListView.builder(
                controller: scrollController,
                itemCount: model.hasMoreLoading
                    ? model.tumKullanicilerListesi.length + 1
                    : model.tumKullanicilerListesi.length,
                itemBuilder: (context, index) {
                  if (model.tumKullanicilerListesi == 0) {
                    return kulliciYokUI();
                  } else if (model.hasMoreLoading &&
                      index == model.tumKullanicilerListesi.length) {
                    return yeniElemanlarYukleniyorIndicator();
                  } else {
                    return userListesiElemanlariOlustur(index);
                  }
                },
              ),
            );
          } else {
            return kulliciYokUI();
          }
        },
      ),
    );
  }

  Widget kulliciYokUI() {
    AllUserViewModel tumKullanicilerViewmodel = Provider.of<AllUserViewModel>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () async {
        return tumKullanicilerViewmodel.refreshIndicator();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: const Center(
            child: Text(
              "Kayıtlı kullanıcı bulunamadı!",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  yeniElemanlarYukleniyorIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  userListesiElemanlariOlustur(index) {
    UserViewmodel _userModel = Provider.of<UserViewmodel>(context, listen: false);
    AllUserViewModel tumKullanicilerViewmodel = Provider.of<AllUserViewModel>(context, listen: false);
    
    var oankiUser = tumKullanicilerViewmodel.tumKullanicilerListesi[index];
    if (oankiUser.userId == _userModel.userModel!.userId) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => KonusmaPage(
                currentUser: _userModel.userModel!,
                sohbetEdilenUser: oankiUser),
          ),
        );
      },
      child: Card(
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: Text(
              oankiUser.userName!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(oankiUser.email),
            leading: CircleAvatar(
                backgroundColor: Colors.grey.withAlpha(20),
                backgroundImage: NetworkImage(oankiUser.profilUrl!)),
          ),
        ),
      ),
    );
  }

  void dahaFazlaKullaniciGetir() async {
    if (_isLoading == false) {
      _isLoading == true;
      final AllUserViewModel tumKullanicilerViewmodel=Provider.of<AllUserViewModel>(context, listen: false);
      await tumKullanicilerViewmodel.dahaFazlaGetir();
      _isLoading == false;
    }
  }

  void listeScrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      dahaFazlaKullaniciGetir();
    }
  }
}
