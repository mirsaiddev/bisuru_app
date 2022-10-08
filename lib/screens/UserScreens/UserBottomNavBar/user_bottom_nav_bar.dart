import 'package:bi_suru_app/providers/bottom_nav_bar_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/NoInternet/no_internet.dart';
import 'package:bi_suru_app/screens/UserScreens/UserSmsVerification/user_sms_verification.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';

class UserBottomNavBar extends StatefulWidget {
  const UserBottomNavBar({Key? key}) : super(key: key);

  @override
  State<UserBottomNavBar> createState() => _UserBottomNavBarState();
}

class _UserBottomNavBarState extends State<UserBottomNavBar> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    NewVersion newVersion = NewVersion(
      androidId: 'com.siberetik.bisuru',
      iOSId: 'com.siberetik.bisuru',
    );
    newVersion.showAlertIfNecessary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel? userModel = userProvider.userModel;
    Color? getColor(index) => bottomNavBarProvider.currentIndex == index ? Theme.of(context).primaryColor : Colors.grey[400];
    if (userModel == null) {
      return SizedBox();
    }
    if (!userModel.smsVerified) {
      return UserSmsVerification();
    }
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }
          if (snapshot.data != ConnectivityResult.wifi && snapshot.data != ConnectivityResult.mobile) {
            return NoInternet();
          }
          return Scaffold(
            body: bottomNavBarProvider.currentPage(),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              currentIndex: bottomNavBarProvider.currentIndex,
              onTap: (val) {
                bottomNavBarProvider.setCurrentIndex(val);
              },
              selectedFontSize: 12,
              unselectedFontSize: 12,
              unselectedItemColor: Colors.grey[400],
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: Image.asset('lib/assets/images/home.png', color: getColor(0), height: 19), label: 'Ana Sayfa'),
                BottomNavigationBarItem(icon: Icon(Icons.category_outlined, color: getColor(1)), label: 'Kategoriler'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_outline, color: getColor(2)), label: 'Kaydedilenler'),
                BottomNavigationBarItem(icon: Image.asset('lib/assets/images/map.png', color: getColor(3), height: 22), label: 'Haritalar'),
                BottomNavigationBarItem(icon: Image.asset('lib/assets/images/profile.png', color: getColor(4), height: 22), label: 'Profilim'),
              ],
            ),
          );
        });
  }
}
