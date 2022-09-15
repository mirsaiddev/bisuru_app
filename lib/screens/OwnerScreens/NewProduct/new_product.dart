import 'dart:io';

import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/storage_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../../widgets/my_list_tile.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController comissionController = TextEditingController();
  String? productImage = 'https://cdn.yemek.com/mnresize/1250/833/uploads/2019/03/kremali-makarna-8.jpg';
  var formKey = GlobalKey<FormState>();

  Future<void> createProduct() async {
    bool validate = formKey.currentState!.validate();
    if (!validate) {
      MySnackbar.show(context, message: 'Lütfen tüm alanları doldurunuz.');
      return;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    OwnerModel ownerModel = userProvider.ownerModel!;
    ProductModel productModel = ProductModel(
      id: int.parse(randomNumeric(6)),
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      comission: double.parse(comissionController.text),
      image: productImage!,
      ownerUid: ownerModel.uid!,
      comments: [],
    );
    await DatabaseService().createProduct(ownerUid: ownerModel.uid!, productModel: productModel);
    Navigator.pop(context);
    MySnackbar.show(context, message: 'Başarıyla ürün oluşturuldu.');
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
                title: 'Yeni Ürün',
                showBackButton: false,
              ),
              SizedBox(height: 10),
              MyListTile(
                onTap: () async {
                  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  print('image: $image');
                  if (image != null) {
                    File imageFile = File(image.path);
                    String imageURL = await StorageService().uploadFile(imageFile, bucketName: 'urunler', folderName: ownerModel.name);
                    setState(() {
                      ownerModel.placePicture = imageURL;
                      productImage = imageURL;
                    });
                  }
                },
                child: Row(
                  children: [
                    Builder(builder: (context) {
                      if (productImage == null) {
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
                              productImage!,
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
                          'Ürün Fotoğrafı',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Ürün fotoğrafını ekleyin', style: TextStyle(fontSize: 14)),
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
                        controller: nameController,
                        text: 'Ürün Adı',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ürün adı boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MyTextfield(
                        controller: descriptionController,
                        text: 'Ürün Açıklaması',
                        maxLines: 3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ürün açıklaması boş bırakılamaz';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextfield(
                              controller: priceController,
                              text: 'Ürün Fiyatı',
                              prefixText: '₺',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ürün fiyatı boş bırakılamaz';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: MyTextfield(
                              text: 'Komisyon Oranı',
                              prefixText: '%',
                              controller: comissionController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Komisyon oranı boş bırakılamaz';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      MyButton(
                        text: 'Oluştur',
                        onPressed: createProduct,
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
