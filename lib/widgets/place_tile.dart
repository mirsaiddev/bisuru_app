import 'package:bi_suru_app/screens/UserScreens/QrCode/qr_code_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/owner_model.dart';
import '../models/product_model.dart';
import '../theme/colors.dart';
import 'my_list_tile.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.productModel,
    required this.ownerModel,
  }) : super(key: key);

  final ProductModel productModel;
  final OwnerModel ownerModel;

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(productModel.image, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ownerModel.placeName!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                  SizedBox(height: 4),
                  Text(productModel.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text(
                    '${productModel.price}₺',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: MyColors.red,
                    ),
                  ),
                ],
              ),
            ),
            if (productModel.enable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QrCodeScreen(
                                  productModel: productModel,
                                )));
                  },
                  icon: Icon(Icons.qr_code_2, size: 30),
                  iconSize: 30,
                ),
              )
          ],
        ),
      ),
    );
  }
}
