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

import '../../../widgets/my_list_tile.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key, required this.productModel}) : super(key: key);

  final ProductModel productModel;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController comissionController = TextEditingController();
  String? productImage;
  var formKey = GlobalKey<FormState>();
  bool enable = true;

  Future<void> createProduct() async {
    bool validate = formKey.currentState!.validate();
    if (!validate) {
      MySnackbar.show(context, message: 'Lütfen tüm alanları doldurunuz.');
      return;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    OwnerModel ownerModel = userProvider.ownerModel!;
    ProductModel productModel = ProductModel(
      id: widget.productModel.id,
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      comission: double.parse(comissionController.text),
      image: productImage!,
      ownerUid: ownerModel.uid!,
      comments: [],
      enable: enable,
    );

    await DatabaseService().editProductModel(ownerUid: ownerModel.uid!, productModel: productModel);
    Navigator.pop(context);
    MySnackbar.show(context, message: 'Başarıyla ürün güncellendi.');
  }

  void setVariables() {
    nameController.text = widget.productModel.name;
    descriptionController.text = widget.productModel.description;
    priceController.text = widget.productModel.price.toString();
    comissionController.text = widget.productModel.comission.toString();
    productImage = widget.productModel.image;
    enable = widget.productModel.enable;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setVariables();
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
                title: 'Ürün Düzenle',
                showBackButton: true,
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
                              text: 'İndirim Oranı',
                              prefixText: '%',
                              controller: comissionController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'İndirim oranı boş bırakılamaz';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      MyListTile(
                        child: SwitchListTile(
                          value: enable,
                          onChanged: (value) => setState(() => enable = value),
                          title: Text('Satın alım aktif'),
                        ),
                      ),
                      SizedBox(height: 20),
                      MyButton(
                        text: 'Güncelle',
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
