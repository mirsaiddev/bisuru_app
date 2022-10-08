import 'dart:convert';
import 'dart:io';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/models/purchase.dart';
import 'package:bi_suru_app/providers/bottom_nav_bar_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeReader extends StatefulWidget {
  const QrCodeReader({Key? key}) : super(key: key);

  @override
  State<QrCodeReader> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool qrCodeReaded = false;

  @override
  void reassemble() {
    super.reassemble();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: (web) {
                    _onQRViewCreated(web);
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Image.asset(
                    'lib/assets/images/reader.png',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: const Text('Karekod okutun'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController _controller) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    OwnerModel ownerModel = userProvider.ownerModel!;

    this.controller = _controller;
    if (Platform.isAndroid) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }

    controller!.scannedDataStream.listen((scanData) async {
      if (scanData.format == BarcodeFormat.qrcode) {
        if (scanData.code != null) {
          try {
            Map data = jsonDecode(scanData.code!);
            print('data: $data');
            String uid = data['uid'];
            String ownerUid = data['ownerUid'];
            int productId = data['productId'];
            String createdDate = data['createdDate'];
            Duration difference = DateTime.now().difference(DateTime.parse(createdDate));

            if (difference.inSeconds < 30) {
              if (ownerUid != ownerModel.uid) {
                if (!qrCodeReaded) {
                  qrCodeReaded = true;
                  MySnackbar.show(context, message: 'Bu ürün size ait değil');
                  return;
                }
              }
              if ((ownerModel.products).any((element) => element.id == productId)) {
                if (!qrCodeReaded) {
                  qrCodeReaded = true;
                  ProductModel productModel = ownerModel.products.firstWhere((element) => element.id == productId);
                  Purchase purchase = Purchase(ownerUid: ownerUid, date: DateTime.now(), productModel: productModel);
                  await userProvider.addReference(userId: uid, productModel: productModel);
                  await DatabaseService().addPurchase(userId: uid, purchase: purchase);
                  BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context, listen: false);
                  bottomNavBarProvider.ownerSetCurrentIndex(1);
                  MySnackbar.show(context, message: 'Başarılı');
                }
              }
            }
          } catch (e) {
            print(e);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
