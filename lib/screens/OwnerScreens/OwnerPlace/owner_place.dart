import 'dart:io';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/SelectCategory/select_category.dart';
import 'package:bi_suru_app/screens/OwnerScreens/SelectLocation/select_location.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/storage_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OwnerPlace extends StatefulWidget {
  const OwnerPlace({Key? key}) : super(key: key);

  @override
  State<OwnerPlace> createState() => _OwnerPlaceState();
}

class _OwnerPlaceState extends State<OwnerPlace> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController longDescriptionController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? placePicture;
  LatLng? location;
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
    nameController.text = ownerModel.placeName ?? '';
    descriptionController.text = ownerModel.placeDescription ?? '';
    longDescriptionController.text = ownerModel.placeLongDescription ?? '';
    contactInfoController.text = ownerModel.contactInfo ?? '';
    categoryController.text = ownerModel.placeCategory != null ? ownerModel.placeCategory.toString() : '';
    locationController.text = ownerModel.placeRealAddress != null ? ownerModel.placeRealAddress! : '';
    location = ownerModel.placeAddress != null ? LatLng(ownerModel.placeAddress!['lat'], ownerModel.placeAddress!['long']) : null;
    placePicture = ownerModel.placePicture;
    if (!ownerModel.placeIsOpen() && ownerModel.enable) {
      ownerModel.enable = false;
      await DatabaseService().updateOwnerData(ownerId: ownerModel.uid!, data: {'enable': false});
    }
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
      data['placeName'] = nameController.text;
      ownerModel.placeName = nameController.text;
    }
    if (descriptionController.text.isNotEmpty) {
      data['placeDescription'] = descriptionController.text;
      ownerModel.placeDescription = descriptionController.text;
    }
    if (longDescriptionController.text.isNotEmpty) {
      data['placeLongDescription'] = longDescriptionController.text;
      ownerModel.placeLongDescription = longDescriptionController.text;
    }
    if (categoryController.text.isNotEmpty) {
      data['placeCategory'] = (categoryController.text);
      ownerModel.placeCategory = (categoryController.text);
    }
    if (contactInfoController.text.isNotEmpty) {
      data['contactInfo'] = contactInfoController.text;
      ownerModel.contactInfo = contactInfoController.text;
    }
    if (locationController.text.isNotEmpty) {
      data['placeRealAddress'] = locationController.text;
      ownerModel.placeRealAddress = locationController.text;
    }
    if (location != null) {
      data['placeAddress'] = {
        'lat': location!.latitude,
        'long': location!.longitude,
      };
      ownerModel.placeAddress = {
        'lat': location!.latitude,
        'long': location!.longitude,
      };
    }
    if (placePicture != null) {
      data['placePicture'] = placePicture;
      ownerModel.placePicture = placePicture;
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
              MyAppBar(
                title: 'Mağazam',
                showBackButton: false,
              ),
              SizedBox(height: 10),
              MyListTile(
                child: SwitchListTile(
                  value: ownerModel.enable,
                  onChanged: (value) async {
                    if (value) {
                      await userProvider.updateOwnerModel();
                      bool canOpen = userProvider.ownerModel!.placeIsOpen();
                      if (canOpen) {
                        await DatabaseService().updateOwnerData(ownerId: ownerModel.uid!, data: {'enable': value});
                        userProvider.ownerModel!.enable = true;
                        MySnackbar.show(context, message: 'Mağaza açıldı');
                      } else {
                        MySnackbar.show(context, message: 'Mağazanızı açabilmeniz için tüm alanları doldurmanız gerekiyor');
                      }
                    } else {
                      await DatabaseService().updateOwnerData(ownerId: ownerModel.uid!, data: {'enable': value});
                      userProvider.ownerModel!.enable = false;
                      MySnackbar.show(context, message: 'Mağaza kapatıldı');
                    }
                    setState(() {});
                  },
                  title: Text('Mağazamı Aç/Kapat'),
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                onTap: () async {
                  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  print('image: $image');
                  if (image != null) {
                    File imageFile = File(image.path);
                    String imageURL = await StorageService().uploadFile(imageFile, bucketName: 'magazalar', folderName: ownerModel.name);
                    setState(() {
                      ownerModel.placePicture = imageURL;
                      placePicture = imageURL;
                    });
                  }
                },
                child: Row(
                  children: [
                    Builder(builder: (context) {
                      if (ownerModel.placePicture == null) {
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
                              ownerModel.placePicture!,
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
                          'Mağaza Fotoğrafı',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Mağazanızın fotoğrafını ekleyin', style: TextStyle(fontSize: 14)),
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                  child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(color: MyColors.lightGrey, borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(ownerModel.placePicture!, fit: BoxFit.cover),
                    ),
                  ),
                  for (int i = 0; i < 4; i++)
                    Container(
                      decoration: BoxDecoration(color: MyColors.lightGrey, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.camera_fill,
                          color: MyColors.lightBlue,
                        ),
                      ),
                    ),
                ],
              )),
              SizedBox(height: 10),
              MyListTile(
                padding: 14,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'Mağaza Adı',
                        controller: nameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Mağaza adı boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'Mağaza Açıklaması',
                        controller: descriptionController,
                        maxLines: 2,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Mağaza açıklaması boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'Uzun Mağaza Açıklaması',
                        controller: longDescriptionController,
                        maxLines: 5,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Mağaza uzun açıklaması boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'İletişim',
                        controller: contactInfoController,
                        maxLines: 2,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'İletişim bilgisi boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'Mağaza Kategorisi',
                        controller: categoryController,
                        readOnly: true,
                        onTap: () async {
                          String? category = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCategory()));
                          if (category != null) {
                            categoryController.text = category;
                            setState(() {});
                          }
                        },
                        hintText: 'Seçiniz',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Mağaza kategorisi boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        text: 'Mağaza Lokasyonu',
                        controller: locationController,
                        readOnly: true,
                        hintText: 'Seçiniz',
                        onTap: () async {
                          LatLng? _location = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectLocation()));
                          if (_location != null) {
                            List<Placemark> placemarks = await placemarkFromCoordinates(_location.latitude, _location.longitude);
                            Placemark placemark = placemarks.first;
                            String city = placemark.locality!;
                            String street = placemark.street!;
                            String address = '$city, $street';
                            locationController.text = address;
                            location = _location;
                            setState(() {});
                          }
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Mağaza lokasyonu boş bırakılamaz';
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
            ],
          ),
        ),
      ),
    ));
  }
}
