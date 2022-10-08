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
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/hive_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/utils/text_input_formatters.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
  TextEditingController taxOfficeController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
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

    bool phoneExists = await DatabaseService().checkPhoneExists(phoneController.text, isUser: false);
    if (phoneExists) {
      MySnackbar.show(context, message: "Bu telefon numarası ile daha önce kayıt yapılmış.");
      return;
    }

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
      taxOffice: taxOfficeController.text,
      taxNumber: taxNumberController.text,
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
          SafeArea(
            bottom: false,
            child: Align(
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
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            denyNumbers,
                          ],
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
                        Text('Telefon'),
                        SizedBox(height: 6),
                        InternationalPhoneNumberInput(
                          inputDecoration: InputDecoration(
                            hintText: '5XX',
                            isDense: true,
                            prefixStyle: TextStyle(color: MyColors.red),
                            contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                            fillColor: MyColors.lightGrey,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          onInputChanged: (val) {},
                          locale: 'TR',
                          errorMessage: 'Hatalı telefon numarası',
                          initialValue: PhoneNumber(isoCode: 'TR'),
                          textFieldController: phoneController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Telefon numarası boş bırakılamaz';
                            }
                            if (val.replaceAll(' ', '').length != 10) {
                              return 'Telefon numarası 10 haneli olmalıdır';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        MyTextfield(
                          text: 'Vergi Numarası',
                          controller: taxNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [allowNumbers],
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Vergi no boş bırakılamaz';
                            }
                            if (text.length != 11) {
                              return 'Vergi no 11 haneli olmalıdır';
                            }

                            print('text.length : ${text.length}');

                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        MyTextfield(
                          text: 'Vergi dairesi',
                          controller: taxOfficeController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Vergi dairesi boş bırakılamaz';
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
                          obscureText: true,
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
                          obscureText: true,
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
          ),
        ],
      ),
    );
  }
}
