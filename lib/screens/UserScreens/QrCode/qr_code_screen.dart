import 'dart:convert';

import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key, required this.productModel}) : super(key: key);

  final ProductModel productModel;

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String getQrData() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String uid = userProvider.userModel!.uid!;
    String ownerUid = widget.productModel.ownerUid;
    int productId = widget.productModel.id;
    String qrData = '';

    Map data = {
      'uid': uid,
      'ownerUid': ownerUid,
      'productId': productId,
      'createdDate': DateTime.now().toString(),
    };

    qrData = jsonEncode(data);
    return qrData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'Karekod', showBackButton: true),
              SizedBox(height: 10),
              Expanded(
                child: MyListTile(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: QrImage(
                          data: getQrData(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
