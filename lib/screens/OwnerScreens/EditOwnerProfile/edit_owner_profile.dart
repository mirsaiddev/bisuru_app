import 'dart:convert';
import 'dart:io';
import 'package:bi_suru_app/models/il_ilce_model.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Premium/premium_screen.dart';
import 'package:bi_suru_app/screens/SelectCityDistrict/select_city_screen.dart';
import 'package:bi_suru_app/screens/SelectCityDistrict/select_district_screen.dart';
import 'package:bi_suru_app/screens/Splash/splash_screen.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/storage_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/utils/text_input_formatters.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditOwnerProfile extends StatefulWidget {
  const EditOwnerProfile({Key? key}) : super(key: key);

  @override
  State<EditOwnerProfile> createState() => _EditOwnerProfileState();
}

class _EditOwnerProfileState extends State<EditOwnerProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  Il? selectedCity;
  Ilce? selectedDistrict;
  String? profilePicUrl;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setVariables();
  }

  Future<void> setVariables() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateOwnerModel();
    OwnerModel ownerModel = userProvider.ownerModel!;
    nameController.text = ownerModel.name;
    emailController.text = ownerModel.email;
    categoryController.text = ownerModel.placeCategory != null ? ownerModel.placeCategory.toString() : '';
    profilePicUrl = ownerModel.placePicture;
    cityController.text = ownerModel.city;
    districtController.text = ownerModel.district;
    String jsonString = await rootBundle.loadString('lib/assets/json/il-ilce.json');

    final dynamic jsonResponse = json.decode(jsonString);

    List cities = jsonResponse.map((x) => Il.fromJson(x)).toList();

    selectedCity = cities.where((element) => element.ilAdi == ownerModel.city).first;

    setState(() {});
  }

  Future<void> update() async {
    bool validate = formKey.currentState!.validate();
    if (!validate) {
      MySnackbar.show(context, message: 'Lütfen tüm alanları doldurunuz');
      return;
    }
    Map<String, dynamic> data = {};
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    OwnerModel ownerModel = userProvider.ownerModel!;
    if (nameController.text.isNotEmpty) {
      data['name'] = nameController.text;
      ownerModel.name = nameController.text;
    }
    if (emailController.text.isNotEmpty) {
      data['email'] = emailController.text;
      ownerModel.email = emailController.text;
    }
    if (profilePicUrl != null) {
      data['profilePicUrl'] = profilePicUrl;
      ownerModel.profilePicUrl = profilePicUrl;
    }
    if (selectedCity != null) {
      data['city'] = selectedCity!.ilAdi;
      ownerModel.city = selectedCity!.ilAdi;
    }
    if (selectedDistrict != null) {
      data['district'] = selectedDistrict!.ilceAdi;
      ownerModel.district = selectedDistrict!.ilceAdi;
    }
    await DatabaseService().updateOwnerData(ownerId: ownerModel.uid!, data: data);
    MySnackbar.show(context, message: 'Güncellendi');
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    OwnerModel ownerModel = userProvider.ownerModel!;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyAppBar(title: 'Profilim', showBackButton: false),
              SizedBox(height: 10),
              MyListTile(
                onTap: () async {
                  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  print('image: $image');
                  if (image != null) {
                    File imageFile = File(image.path);
                    String imageURL = await StorageService().uploadFile(imageFile, bucketName: 'profilResimleri', folderName: ownerModel.name);
                    setState(() {
                      ownerModel.profilePicUrl = imageURL;
                      profilePicUrl = imageURL;
                    });
                  }
                },
                child: Row(
                  children: [
                    Builder(builder: (context) {
                      if (ownerModel.profilePicUrl == null) {
                        return Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(color: MyColors.lightGrey, borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.camera_fill,
                              color: MyColors.lightBlue,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              ownerModel.profilePicUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    }),
                    SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil Fotoğrafı',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Profil fotoğrafını ekleyin', style: TextStyle(fontSize: 14)),
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                padding: 14,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      MyTextfield(
                        readOnly: true,
                        text: 'Ad soyad',
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          denyNumbers,
                        ],
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Mağaza adı boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'E-posta',
                        readOnly: true,
                        controller: emailController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'E-posta boş bırakılamaz';
                          }
                          if (!val.isValidEmail()) {
                            return 'Geçerli bir e-posta giriniz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
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
                      SizedBox(height: 20),
                      MyButton(
                        text: 'Güncelle',
                        onPressed: update,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (!ownerModel.premium)
                MyButton(
                  text: 'Premium',
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumScreen()));
                  },
                ),
              SizedBox(height: 10),
              MyButton(
                text: 'Çıkış Yap',
                onPressed: () async {
                  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                  await AuthService().logout();
                  userProvider.setAuthStatus(AuthStatus.notLoggedIn);
                  userProvider.setUserModel(null);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
