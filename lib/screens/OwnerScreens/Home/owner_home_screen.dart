import 'package:bi_suru_app/models/campaign.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/EditProduct/edit_product.dart';
import 'package:bi_suru_app/screens/OwnerScreens/NewProduct/new_product.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerCampaignDetail/owner_campaign_detail.dart';
import 'package:bi_suru_app/screens/OwnerScreens/OwnerProducts/owner_products.dart';
import 'package:bi_suru_app/screens/OwnerScreens/Premium/premium_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/CampaignDetail/campaign_detail.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
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
                      Campaign campaign = systemProvider.campaigns[index % systemProvider.campaigns.length];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 2 / 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerCampaignDetail(campaign: campaign)));
                            },
                            child: Container(
                              child: Image.network(campaign.campaignImage, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('Son Kampanyalar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                //     TextButton(
                //         onPressed: () {
                //           Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerProducts()));
                //         },
                //         child: Text('Tümünü Gör'))
                //   ],
                // ),
                // SizedBox(height: 10),
                // for (Campaign campaign in systemProvider.campaigns) MyListTile(child: Text(campaign.campaignName)),
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

                      if (products.isEmpty) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              MyListTile(
                                child: Center(child: Text('Henüz ürün eklememişsiniz.')),
                              ),
                              SizedBox(height: 20),
                              MyButton(
                                text: 'Ürün Oluştur',
                                onPressed: () {
                                  OwnerModel ownerModel = userProvider.ownerModel!;
                                  if (!ownerModel.placeIsOpen()) {
                                    MySnackbar.show(context, message: 'Mağazanız kapalı olduğu için ürün ekleyemezsiniz.');
                                    return;
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewProduct()));
                                },
                              )
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          ProductModel productModel = products[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(productModel: productModel)));
                              },
                              child: ProductWidget(productModel: productModel, ownerModel: ownerModel));
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
