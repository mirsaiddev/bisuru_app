import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/Onboarding/onboarding_screen.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerBottomNavBar/owner_bottom_nav_bar.dart';
import 'package:bi_suru_app/screens/UserScreens/Login/login_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/UserBottomNavBar/user_bottom_nav_bar.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/hive_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  bool? loggedIn;
  bool? onboardingShown;

  void navigate() {
    system();
    Future.delayed(const Duration(seconds: 1), () async {
      check();
    });
  }

  void system() {
    SystemProvider systemProvider = Provider.of<SystemProvider>(context, listen: false);
    systemProvider.getSliders();
    systemProvider.getCategories();
  }

  Future<void> check() async {
    loggedIn = (await AuthService().getUser()) != null;
    onboardingShown = await HiveService().get('onboarding-shown') ?? false;
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    print('loggedIn: $loggedIn');

    if (loggedIn != true) {
      userProvider.setAuthStatus(AuthStatus.notLoggedIn);
      if (onboardingShown == true) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      } else {
        HiveService().set('onboarding-shown', true);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OnboardingScreen()), (route) => false);
      }
    }

    if (loggedIn == true) {
      userProvider.setAuthStatus(AuthStatus.loggedIn);
      String userType = await HiveService().get('user-type') ?? 'user';
      if (userType == 'user') {
        UserModel? userModel = await DatabaseService().getUserModel();
        if (userModel != null) {
          userProvider.setUserModel(userModel);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserBottomNavBar()), (route) => false);
        }
      } else if (userType == 'owner') {
        OwnerModel? ownerModel = await DatabaseService().getOwnerModel();
        if (ownerModel != null) {
          userProvider.setOwnerModel(ownerModel);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OwnerBottomNavBar()), (route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("lib/assets/images/background.png"), fit: BoxFit.cover),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MyColors.red2, MyColors.orange]),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyLogoWidget(),
              SizedBox(width: 10),
              Text(
                'BiSürü',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
