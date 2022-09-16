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
            MyListTile(child: Text(widget.ownerModel.placeDescription ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
            SizedBox(height: 10),
            MyListTile(child: Text(widget.ownerModel.placeLongDescription ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
            SizedBox(height: 10),
          ],
        ),
      )),
    );
  }
}
