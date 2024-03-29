import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/responses/auth_response.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Home/owner_home_screen.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerBottomNavBar/owner_bottom_nav_bar.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerRegister/owner_register_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Home/user_home_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Login/login_screen.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/hive_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/forgot_password_dialog.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({Key? key}) : super(key: key);

  @override
  State<OwnerLoginScreen> createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  TextEditingController emailController = kDebugMode ? TextEditingController(text: 'c2canplt@gmail.com') : TextEditingController();
  TextEditingController passwordController = kDebugMode ? TextEditingController(text: '123456') : TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    AuthResponse authResponse = await AuthService().login(email: emailController.text, password: passwordController.text);

    if (!authResponse.isSuccessful) {
      MySnackbar.show(context, message: authResponse.message);
      return;
    }

    OwnerModel? ownerModel = await DatabaseService().getOwnerModel();

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    if (ownerModel == null) {
      MySnackbar.show(context, message: 'Bir hata oluştu, lütfen tekrar deneyin');
      return;
    }

    if (!ownerModel.isOwner) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }

    await HiveService().set('user-type', 'owner');
    userProvider.setOwnerModel(ownerModel);
    userProvider.setAuthStatus(AuthStatus.loggedIn);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OwnerBottomNavBar()), (route) => false);
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
                        'BiSürü\nMekan Sahibi',
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
                      obscureText: true,
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ForgotPasswordDialog(),
                          );
                        },
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
                          MySnackbar.show(context, message: 'Tüm alanları doldurunuz.');
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerRegisterScreen()));
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'Kullanıcı Girişi',
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
