import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerProducts/owner_products.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Premium/premium_screen.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:bi_suru_app/widgets/product_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    OwnerModel ownerModel = userProvider.ownerModel!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyLogoWidgetColored(radius: 20, padding: 8),
                        SizedBox(width: 6),
                        Text('BiSürü', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Image.asset('lib/assets/images/location.png', width: 14),
                          SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lokasyonunuz', style: TextStyle(fontSize: 8)),
                              Text(ownerModel.city, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!ownerModel.placeIsOpen())
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: MyListTile(
                      padding: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: double.infinity),
                          Text(
                            'Dikkat!',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Lütfen mağazam sayfasından mağazanızın bilgilerini doldurunuz.',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                          ),
                        ],
                      ),
                      color: MyColors.red,
                    ),
                  ),
                SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                            aspectRatio: 2 / 1, child: Container(child: Image.network(systemProvider.sliders[index % systemProvider.sliders.length]))),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ürünlerim', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerProducts()));
                        },
                        child: Text('Tümünü Gör'))
                  ],
                ),
                StreamBuilder<DatabaseEvent>(
                    stream: DatabaseService().productsStream(ownerModel.uid!),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      Map productsMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                      List<ProductModel> products = productsMap.entries.map((e) => ProductModel.fromMap(e.value)).toList();

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          ProductModel productModel = products[index];
                          return ProductWidget(productModel: productModel, ownerModel: ownerModel);
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
