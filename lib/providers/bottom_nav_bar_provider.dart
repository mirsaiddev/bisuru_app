import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Home/owner_home_screen.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerPlace/owner_place.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerProfile/owner_profile.dart';
import 'package:bi_suru_app/screens/OwnerScreens/QrCodeReader/qr_code_reader.dart';
import 'package:bi_suru_app/screens/OwnerScreens/References/references.dart';
import 'package:bi_suru_app/screens/Splash/splash_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Categories/categories_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Home/user_home_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/MapsScreen/maps_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/UserProfile/user_profile.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/UserScreens/SavedPlaces/saved_places.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int currentIndex = 0;
  int ownerCurrentIndex = 0;

  List<Widget> pages = [
    const UserHomeScreen(),
    const CategoriesScreen(),
    const SavedPlaces(),
    const MapsScreen(),
    const UserProfile(),
  ];

  List<Widget> ownerPages = [
    const OwnerHomeScreen(),
    const ReferencesScreen(),
    const QrCodeReader(),
    const OwnerPlace(),
    const OwnerProfile(),
  ];

  Widget currentPage() {
    return pages[currentIndex];
  }

  Widget ownerCurrentPage() {
    return ownerPages[ownerCurrentIndex];
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void ownerSetCurrentIndex(int index) {
    ownerCurrentIndex = index;
    notifyListeners();
  }
}

class Test extends StatelessWidget {
  const Test({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Owner Home'),
        TextButton(
          onPressed: () async {
            UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
            await AuthService().logout();
            userProvider.setAuthStatus(AuthStatus.notLoggedIn);
            userProvider.setUserModel(null);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
          },
          child: Text('Logout'),
        ),
      ],
    ));
  }
}
