import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: MyColors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: 50,
                    child: Center(child: Image.asset('lib/assets/images/market.png', height: 20)),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Text('Mağaza Ortalama Puanı', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  Container(
                    decoration: BoxDecoration(color: MyColors.grey, borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons.star, color: MyColors.yellow),
                          SizedBox(width: 6),
                          Text(widget.ownerModel.getAverageRating().toStringAsFixed(2), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
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
                    'Hakkında',
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
            MyListTile(
              padding: 16,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mağaza Adresi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(widget.ownerModel.placeRealAddress ?? '')
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        MapsLauncher.launchCoordinates(widget.ownerModel.placeAddress!['lat'], widget.ownerModel.placeAddress!['long']);
                      },
                      icon: Icon(Icons.link)),
                ],
              ),
            ),
            SizedBox(height: 10),
            MyListTile(
              onTap: () {},
              padding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İletişim Bilgisi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(widget.ownerModel.contactInfo ?? 'Henüz eklenmedi')
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
