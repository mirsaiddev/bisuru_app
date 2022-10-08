import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/product_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PlaceAllProducts extends StatefulWidget {
  const PlaceAllProducts({Key? key, required this.ownerModel}) : super(key: key);

  final OwnerModel ownerModel;

  @override
  State<PlaceAllProducts> createState() => _PlaceAllProductsState();
}

class _PlaceAllProductsState extends State<PlaceAllProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyAppBar(title: 'Mağaza Ürünleri', showBackButton: true),
              SizedBox(height: 10),
              StreamBuilder<DatabaseEvent>(
                stream: DatabaseService().productsStream(widget.ownerModel.uid!),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  Map productsMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                  List<ProductModel> products = productsMap.entries.map((e) => ProductModel.fromMap(e.value)).toList();
                  return Column(
                    children: [
                      for (ProductModel productModel in products)
                        Padding(padding: const EdgeInsets.only(bottom: 10.0), child: ProductTile(productModel: productModel, ownerModel: widget.ownerModel)),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
