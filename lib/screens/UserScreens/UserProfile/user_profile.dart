import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Premium/premium_screen.dart';
import 'package:bi_suru_app/screens/Splash/splash_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/EditUserProfile/edit_user_profile.dart';
import 'package:bi_suru_app/screens/UserScreens/PremiumPlaces/premium_places.dart';
import 'package:bi_suru_app/screens/UserScreens/PremiumScreen/user_premium_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Purchases/purchases_screen.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: StreamBuilder<DatabaseEvent>(
                stream: DatabaseService().userStream(userModel.uid!),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox();
                  }
                  Map userMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                  UserModel userModel = UserModel.fromJson(userMap);
                  return Column(
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
                              backgroundImage: userModel.profilePicUrl != null ? NetworkImage(userModel.profilePicUrl!) : null,
                              backgroundColor: MyColors.grey,
                              child: userModel.profilePicUrl == null ? Icon(Icons.person, size: 50, color: Colors.grey) : null,
                            ),
                            SizedBox(height: 10),
                            Text(
                              userModel.fullName,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      MyListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPlacesScreen()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.black),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(title: Text('Bi Puanım'), subtitle: Text(userModel.points.toString() + ' Puan')),
                                ],
                              ),
                            ),
                            if (userModel.points > 100)
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPlacesScreen()));
                                },
                                child: Text('Kullan'),
                              ),
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
                              child: ListTile(title: Text('E-posta'), subtitle: Text(userModel.email)),
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
                              child: ListTile(title: Text('Telefon Numarası'), subtitle: Text(userModel.phone)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      MyListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PurchasesScreen()));
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 6),
                            Icon(Icons.restore, color: Colors.black),
                            Expanded(
                              child: ListTile(title: Text('Geçmiş Satın Alımlarım'), subtitle: Text('Geçmiş satın alımlarınızı görüntüleyebilirsiniz.')),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      if (!userModel.premium) ...[
                        MyListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserPremiumScreen()));
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 6),
                              Icon(Icons.add, color: Colors.black),
                              Expanded(
                                child: ListTile(title: Text('Premium Ol'), subtitle: Text('Premium olarak ürünlerin karekodlarını açabilirsiniz.')),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ] else ...[
                        MyListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserPremiumScreen()));
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 6),
                              Icon(Icons.add, color: Colors.black),
                              Expanded(
                                child: ListTile(title: Text('Premium Ol'), subtitle: Text('Premium olarak ürünlerin karekodlarını açabilirsiniz.')),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
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
                                          Navigator.pushAndRemoveUntil(
                                              context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
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
                  );
                }),
          ),
        ),
      ),
    );
  }
}
