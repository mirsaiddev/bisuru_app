import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/NewProduct/new_product.dart';
import 'package:bi_suru_app/screens/UserScreens/PlaceDetail/place_detail.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/slidable_product_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class OwnerProducts extends StatefulWidget {
  const OwnerProducts({Key? key}) : super(key: key);

  @override
  State<OwnerProducts> createState() => _OwnerProductsState();
}

class _OwnerProductsState extends State<OwnerProducts> {
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
              children: [
                MyAppBar(
                  title: 'Ürünler',
                  showBackButton: true,
                ),
                SizedBox(height: 10),
                MyListTile(
                  onTap: () {
                    OwnerModel ownerModel = userProvider.ownerModel!;
                    if (!ownerModel.placeIsOpen()) {
                      MySnackbar.show(context, message: 'Mağazanız kapalı olduğu için ürün ekleyemezsiniz.');
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewProduct()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/images/add.png', height: 22),
                      SizedBox(width: 8),
                      Text('Ürün Ekle', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                MyListTile(
                  child: Center(
                    child: Text(
                      'Düzenlemek için sola kaydırın',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                StreamBuilder<DatabaseEvent>(
                  stream: DatabaseService().productsStream(ownerModel.uid!),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    Map productsMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                    List<ProductModel> products = productsMap.entries.map((e) => ProductModel.fromMap(e.value)).toList();
                    return Column(
                      children: [
                        for (ProductModel productModel in products)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: SlidableProductTile(productModel: productModel, ownerModel: ownerModel),
                          ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
