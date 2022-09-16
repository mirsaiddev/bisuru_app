import 'package:bi_suru_app/providers/bottom_nav_bar_provider.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    placesProvider.getAllPlaces(userProvider.userModel!.city);
  }

  @override
  Widget build(BuildContext context) {
    BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);
    Color? getColor(index) => bottomNavBarProvider.currentIndex == index ? Theme.of(context).primaryColor : Colors.grey[400];

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
  }
}
