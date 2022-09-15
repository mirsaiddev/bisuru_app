import 'package:bi_suru_app/models/il_ilce_model.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/responses/auth_response.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Home/owner_home_screen.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerBottomNavBar/owner_bottom_nav_bar.dart';
import 'package:bi_suru_app/screens/SelectCityDistrict/select_city_screen.dart';
import 'package:bi_suru_app/screens/SelectCityDistrict/select_district_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Home/user_home_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Login/login_screen.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/services/hive_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnerRegisterScreen extends StatefulWidget {
  const OwnerRegisterScreen({Key? key}) : super(key: key);

  @override
  State<OwnerRegisterScreen> createState() => _OwnerRegisterScreenState();
}

class _OwnerRegisterScreenState extends State<OwnerRegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  Il? selectedCity;
  Ilce? selectedDistrict;
  bool acceptTerms = false;
  final formKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (selectedCity == null || selectedDistrict == null) {
      MySnackbar.show(context, message: "Lütfen şehir ve ilçeyi seçiniz.");
      return;
    }

    OwnerModel ownerModel = await setOwnerModel();

    AuthResponse authResponse = await AuthService().ownerRegister(
      ownerModel: ownerModel,
      password: passwordController.text,
    );

    if (!authResponse.isSuccessful) {
      MySnackbar.show(context, message: authResponse.message);
      return;
    }

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setOwnerModel(ownerModel);
    await HiveService().set('user-type', 'owner');
    MySnackbar.show(context, message: 'Başarılı bir şekilde kayıt oluşturuldu, id : ${authResponse.user!.uid}');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OwnerBottomNavBar()), (route) => false);
  }

  OwnerModel setOwnerModel() {
    OwnerModel ownerModel = OwnerModel(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      city: selectedCity!.ilAdi,
      district: selectedDistrict!.ilceAdi,
      enable: false,
      products: [],
      comments: [],
    );

    return ownerModel;
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
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyTextfield(
                        text: 'Ad soyad',
                        controller: nameController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Ad soyad boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
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
                        text: 'Telefon',
                        controller: phoneController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Telefon boş bırakılamaz';
                          }
                          if (text.length < 9 || text.length > 11) {
                            return 'Geçerli bir telefon giriniz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'Şehir',
                        readOnly: true,
                        controller: cityController,
                        onTap: () async {
                          Il? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCityScreen()));
                          if (result != null) {
                            cityController.text = result.ilAdi;
                            selectedCity = result;
                            setState(() {});
                          }
                        },
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Şehir boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'İlçe',
                        readOnly: true,
                        controller: districtController,
                        onTap: () async {
                          if (selectedCity == null) {
                            MySnackbar.show(context, message: 'Lütfen önce şehir seçiniz');
                            return;
                          }
                          Ilce? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectDistrictScreen(
                                        selectedCity: selectedCity!,
                                      )));
                          if (result != null) {
                            districtController.text = result.ilceAdi;
                            selectedDistrict = result;
                            setState(() {});
                          }
                        },
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'İlçe boş bırakılamaz';
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
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'Şifre Tekrar',
                        controller: passwordAgainController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Şifre boş bırakılamaz';
                          }
                          if (text.length < 6) {
                            return 'Şifre en az 6 karakter olmalıdır';
                          }
                          if (text != passwordController.text) {
                            return 'Şifreler uyuşmuyor';
                          }
                          return null;
                        },
                      ),
                      CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: acceptTerms,
                        onChanged: (val) {
                          setState(() {
                            acceptTerms = val!;
                          });
                        },
                        title: Text('Kullanım koşullarını okudum, anladım ve kabul ediyorum.'),
                      ),
                      SizedBox(height: 20),
                      MyButton(
                          text: 'Kayıt Ol',
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tüm alanları doldurunuz.')));
                              return;
                            }
                            if (!acceptTerms) {
                              MySnackbar.show(context, message: 'Kullanım koşullarını kabul etmelisiniz');
                              return;
                            }
                            await register();
                          }),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Hesabın var mı?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Giriş Yap',
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
          ),
        ],
      ),
    );
  }
}
