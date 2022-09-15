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
            onPressed: (val) {},
            backgroundColor: MyColors.blue,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.pencil,
          ),
          SizedBox(width: 10),
          SlidableAction(
            borderRadius: BorderRadius.circular(10),
            onPressed: (val) {},
            backgroundColor: MyColors.red,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
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
              Column(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
