import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Premium/premium_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/QrCode/qr_code_screen.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/owner_model.dart';
import '../models/product_model.dart';
import '../screens/UserScreens/PremiumScreen/user_premium_screen.dart';
import '../theme/colors.dart';
import 'my_list_tile.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.productModel,
    required this.ownerModel,
    this.useFree = false,
  }) : super(key: key);

  final ProductModel productModel;
  final OwnerModel ownerModel;
  final bool useFree;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
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
                    productModel.description,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${productModel.price} ₺',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black38, decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${productModel.getDiscountPrice().toStringAsFixed(1)} ₺',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColors.red),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (productModel.enable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () async {
                    if (!ownerModel.enable) {
                      MySnackbar.show(context, message: 'Bu işletme şu anda kapalıdır.');
                      return;
                    }
                    SystemProvider systemProvider = Provider.of<SystemProvider>(context, listen: false);
                    int freePurchaseCount = systemProvider.freePurchaseCount;
                    if (!userModel.premium && userModel.purchases.length > freePurchaseCount) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserPremiumScreen()));
                      MySnackbar.show(context, message: 'Premium üyeliğin olmadan $freePurchaseCount\'den fazla ürün satın alamazsın.');
                      return;
                    }
                    if (userModel.purchases.length < freePurchaseCount) {
                      if (useFree) {
                        if (userModel.points > 100) {
                          await DatabaseService().decreasePoints(uid: userModel.uid!, points: 100);
                          userModel.points -= 100;
                          userProvider.setUserModel(userModel);
                        } else {
                          MySnackbar.show(context, message: 'Yeterli puanınız yok.');
                          return;
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrCodeScreen(
                            productModel: productModel,
                          ),
                        ),
                      );
                    }
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
