import 'package:bi_suru_app/screens/OwnerScreens/EditProduct/edit_product.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/owner_model.dart';
import '../models/product_model.dart';
import '../theme/colors.dart';
import 'my_list_tile.dart';

class SlidableProductTile extends StatelessWidget {
  const SlidableProductTile({
    Key? key,
    required this.productModel,
    required this.ownerModel,
  }) : super(key: key);

  final ProductModel productModel;
  final OwnerModel ownerModel;

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      child: Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(10),
            onPressed: (val) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(productModel: productModel)));
            },
            backgroundColor: MyColors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SizedBox(width: 10),
          SlidableAction(
            borderRadius: BorderRadius.circular(10),
            onPressed: (val) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Dikkat'),
                  content: Text('Ürünü silmek istediğinize emin misiniz?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Hayır')),
                    TextButton(
                      onPressed: () async {
                        await DatabaseService().deleteProduct(ownerUid: ownerModel.uid!, productModel: productModel);
                        Navigator.pop(context);
                      },
                      child: Text('Evet'),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: MyColors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ]),
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
                    Text(productModel.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      productModel.description,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
