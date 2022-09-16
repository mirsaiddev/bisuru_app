import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/Splash/splash_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/EditUserProfile/edit_user_profile.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnerProfile extends StatefulWidget {
  const OwnerProfile({Key? key}) : super(key: key);

  @override
  State<OwnerProfile> createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    OwnerModel ownerModel = userProvider.ownerModel!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(
                title: 'Profilim',
                showBackButton: false,
                action: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserProfile()));
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: ownerModel.profilePicUrl != null ? NetworkImage(ownerModel.profilePicUrl!) : null,
                      backgroundColor: MyColors.grey,
                      child: ownerModel.profilePicUrl == null ? Icon(Icons.person, size: 50, color: Colors.grey) : null,
                    ),
                    SizedBox(height: 10),
                    Text(
                      ownerModel.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                child: Row(
                  children: [
                    SizedBox(width: 6),
                    Icon(Icons.email, color: Colors.black),
                    Expanded(
                      child: ListTile(title: Text('E-posta'), subtitle: Text(ownerModel.email)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                child: Row(
                  children: [
                    SizedBox(width: 6),
                    Icon(Icons.phone, color: Colors.black),
                    Expanded(
                      child: ListTile(title: Text('Telefon Numarası'), subtitle: Text(ownerModel.phone)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Dikkat'),
                            content: Text('Çıkış yapmak istediğinize emin misiniz?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text('Hayır')),
                              TextButton(
                                onPressed: () async {
                                  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                                  await AuthService().logout();
                                  userProvider.setAuthStatus(AuthStatus.notLoggedIn);
                                  userProvider.setUserModel(null);
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
                                },
                                child: Text('Evet'),
                              ),
                            ],
                          ));
                },
                child: Row(
                  children: [
                    SizedBox(width: 6),
                    Icon(Icons.logout, color: MyColors.red),
                    Expanded(
                      child: ListTile(title: Text('Çıkış Yap'), subtitle: Text('Çıkış yapmak için tıklayın')),
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
