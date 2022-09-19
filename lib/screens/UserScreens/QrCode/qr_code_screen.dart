import 'dart:async';
import 'dart:convert';

import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("lib/assets/images/background.png"), fit: BoxFit.cover),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MyColors.red2, MyColors.orange]),
        ),
        child: SafeArea(
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
                      color: Colors.transparent,
                      // gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MyColors.red2, MyColors.orange]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: MyListTile(
                              color: Colors.white,
                              padding: 14,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: double.infinity),
                                        Text(
                                          'Ürün',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                        Text(
                                          '${widget.productModel.name}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${widget.productModel.price} ₺',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          MyListTile(
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: double.infinity),
                                    Text(
                                      'Müşteri',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    Text(
                                      '${userModel.fullName}',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                    ),
                                  ],
                                )),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: userModel.profilePicUrl != null ? NetworkImage(userModel.profilePicUrl!) : null,
                                  child: userModel.profilePicUrl == null ? Icon(Icons.person, size: 30, color: Colors.grey) : null,
                                  backgroundColor: MyColors.grey,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: QrImage(data: qrData!),
                              ),
                            ),
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
      ),
    );
  }
}
