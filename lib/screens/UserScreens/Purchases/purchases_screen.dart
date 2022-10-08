import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/purchase.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/date_formatters.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel userModel = userProvider.userModel!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyAppBar(title: 'Satın Alımlar', showBackButton: true),
                SizedBox(height: 10),
                // MyListTile(
                //   child: Row(
                //     children: [
                //       TextButton(onPressed: () {}, child: Text('Tarih Aralığı')),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 10),
                StreamBuilder<DatabaseEvent>(
                  stream: DatabaseService().purchasesStream(userModel.uid!),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return SizedBox();
                    }
                    Map purchasesMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                    List<Purchase> purchases = purchasesMap.entries.map((e) => Purchase.fromMap(e.value as Map)).toList();
                    purchases.sort((a, b) => b.date.compareTo(a.date));

                    return Column(
                      children: [
                        for (Purchase purchase in purchases)
                          StreamBuilder<DatabaseEvent>(
                            stream: DatabaseService().ownerStream(purchase.ownerUid),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return SizedBox();
                              }
                              Map userMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                              OwnerModel ownerModel = OwnerModel.fromJson(userMap);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: MyListTile(
                                  child: Row(
                                    children: [
                                      ownerModel.profilePicUrl != null
                                          ? ClipRRect(
                                              child: Image.network(ownerModel.profilePicUrl!, height: 50, width: 50), borderRadius: BorderRadius.circular(10))
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(color: MyColors.grey, borderRadius: BorderRadius.circular(10)),
                                              child: Center(child: Icon(Icons.person)),
                                            ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(ownerModel.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(purchase.productModel.name),
                                            Row(
                                              children: [
                                                Text(
                                                  '${purchase.productModel.price} ₺',
                                                  style: TextStyle(
                                                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black38, decoration: TextDecoration.lineThrough),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  '${purchase.productModel.getDiscountPrice().toStringAsFixed(1)} ₺',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColors.red),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(purchase.date.toDateStringWithTime()),
                                    ],
                                  ),
                                ),
                              );
                            },
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
