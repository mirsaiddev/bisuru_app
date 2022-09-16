import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';

class AboutOwner extends StatefulWidget {
  const AboutOwner({Key? key, required this.ownerModel}) : super(key: key);

  final OwnerModel ownerModel;

  @override
  State<AboutOwner> createState() => _AboutOwnerState();
}

class _AboutOwnerState extends State<AboutOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            MyAppBar(title: 'Mağaza Hakkında', showBackButton: true),
            SizedBox(height: 10),
            MyListTile(
              padding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Açıklama',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(widget.ownerModel.placeDescription ?? '')
                ],
              ),
            ),
            SizedBox(height: 10),
            MyListTile(
              padding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Uzun Açıklama',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(widget.ownerModel.placeLongDescription ?? '')
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      )),
    );
  }
}
