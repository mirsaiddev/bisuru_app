import 'dart:async';
import 'dart:convert';

import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../theme/colors.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key, required this.productModel}) : super(key: key);

  final ProductModel productModel;

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String time = '';
  String? qrData;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    getQrData();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick % 30 == 0) {
        getQrData();
      }
      time = (30 - (timer.tick % 30)).toString();
      setState(() {});
    });
  }

  void getQrData() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String uid = userProvider.userModel!.uid!;
    String ownerUid = widget.productModel.ownerUid;
    int productId = widget.productModel.id;
    String _qrData = '';

    Map data = {
      'uid': uid,
      'ownerUid': ownerUid,
      'productId': productId,
      'createdDate': DateTime.now().toString(),
    };

    _qrData = jsonEncode(data);
    qrData = base64Encode(utf8.encode(_qrData));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(
                title: 'Karekod',
                showBackButton: true,
                action: Center(child: Text(time)),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Builder(builder: (context) {
                  if (qrData == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return MyListTile(
                    child: Column(
                      children: [
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
                                  'Güvenlik sebebiyle her 30 saniyede bir kod değişecektir.',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                                ),
                              ],
                            ),
                            color: MyColors.red,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: QrImage(data: qrData!),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
