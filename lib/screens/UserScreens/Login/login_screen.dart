import 'package:bi_suru_app/models/responses/auth_response.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerLogin/owner_login_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Home/user_home_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Register/register_screen.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/hive_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UserBottomNavBar/user_bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = kDebugMode ? TextEditingController(text: 'mirsaid@gmail.com') : TextEditingController();
  TextEditingController passwordController = kDebugMode ? TextEditingController(text: '123456') : TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    AuthResponse authResponse = await AuthService().login(email: emailController.text, password: passwordController.text);

    if (!authResponse.isSuccessful) {
      MySnackbar.show(context, message: authResponse.message);
      return;
    }

    UserModel? userModel = await DatabaseService().getUserModel();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userModel == null) {
      MySnackbar.show(context, message: 'Bir hata oluştu, lütfen tekrar deneyin');
      return;
    }

    if (userModel.isOwner) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OwnerLoginScreen()));
    }

    await HiveService().set('user-type', 'user');
    userProvider.setUserModel(userModel);
    userProvider.setAuthStatus(AuthStatus.loggedIn);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const UserBottomNavBar()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("lib/assets/images/background.png"), fit: BoxFit.cover),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MyColors.red2, MyColors.orange]),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextfield(
                      text: 'E-posta',
                      controller: emailController,
                      validator: (text) {
                        if (text!.isEmpty) {
                          return 'E-posta boş bırakılamaz';
                        }
                        if (!text.isValidEmail()) {
                          return 'Geçerli bir e-posta giriniz';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    MyTextfield(
                      text: 'Şifre',
                      controller: passwordController,
                      validator: (text) {
                        if (text!.isEmpty) {
                          return 'Şifre boş bırakılamaz';
                        }
                        if (text.length < 6) {
                          return 'Şifre en az 6 karakter olmalıdır';
                        }

                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Şifremi Unuttum',
                          style: TextStyle(color: MyColors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MyButton(
                      text: 'Giriş Yap',
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tüm alanları doldurunuz.')));
                          return;
                        }
                        await login();
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hesabın yok mu?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            'Kayıt Ol',
                            style: TextStyle(color: MyColors.red),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerLoginScreen()));
                      },
                      child: Text(
                        'Mekan Sahibi Girişi',
                        style: TextStyle(color: MyColors.red),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
