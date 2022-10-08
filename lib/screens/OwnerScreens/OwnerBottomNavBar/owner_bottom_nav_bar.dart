import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/bottom_nav_bar_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/NoInternet/no_internet.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerSmsVerification/owner_sms_verification.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnerBottomNavBar extends StatefulWidget {
  const OwnerBottomNavBar({Key? key}) : super(key: key);

  @override
  State<OwnerBottomNavBar> createState() => _OwnerBottomNavBarState();
}

class _OwnerBottomNavBarState extends State<OwnerBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    OwnerModel? ownerModel = userProvider.ownerModel;
    Color? getColor(index) => bottomNavBarProvider.ownerCurrentIndex == index ? Theme.of(context).primaryColor : Colors.grey[400];
    if (ownerModel == null) {
      return SizedBox();
    }
    if (!ownerModel.smsVerified) {
      return OwnerSmsVerification();
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
            body: bottomNavBarProvider.ownerCurrentPage(),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              currentIndex: bottomNavBarProvider.ownerCurrentIndex,
              onTap: (val) {
                bottomNavBarProvider.ownerSetCurrentIndex(val);
              },
              selectedFontSize: 12,
              unselectedFontSize: 12,
              unselectedItemColor: Colors.grey[400],
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: Image.asset('lib/assets/images/home.png', color: getColor(0), height: 19), label: 'Ana Sayfa'),
                BottomNavigationBarItem(icon: Image.asset('lib/assets/images/reference.png', color: getColor(1), height: 22), label: 'Referanslar'),
                BottomNavigationBarItem(icon: Icon(Icons.qr_code, color: getColor(2)), label: 'Karekod'),
                BottomNavigationBarItem(icon: Image.asset('lib/assets/images/store.png', color: getColor(3), height: 22), label: 'Mağazam'),
                BottomNavigationBarItem(icon: Image.asset('lib/assets/images/profile.png', color: getColor(4), height: 22), label: 'Profilim'),
              ],
            ),
          );
        });
  }
}
