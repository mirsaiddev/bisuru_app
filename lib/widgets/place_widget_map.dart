import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/UserScreens/PlaceDetail/place_detail.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceWidgetMap extends StatefulWidget {
  const PlaceWidgetMap({
    Key? key,
    required this.ownerModel,
    required this.onClose,
  }) : super(key: key);

  final OwnerModel ownerModel;
  final Function onClose;

  @override
  State<PlaceWidgetMap> createState() => _PlaceWidgetMapState();
}

class _PlaceWidgetMapState extends State<PlaceWidgetMap> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
    bool isSaved = userModel.savedPlaces.contains(widget.ownerModel.uid);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetail(ownerModel: widget.ownerModel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    MapsLauncher.launchCoordinates(widget.ownerModel.placeAddress!['lat'], widget.ownerModel.placeAddress!['long']);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/images/google-maps.png', width: 26),
                      Text('Yol Tarifi', style: TextStyle(fontSize: 10, color: Colors.black)),
                    ],
                  ),
                ),
                Text(
                  widget.ownerModel.placeName!,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      widget.onClose();
                    },
                    icon: Icon(Icons.close)),
              ],
            ),
            SizedBox(height: 6),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.ownerModel.placePicture!,
                  height: 74,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.ownerModel.placeDescription!,
                  maxLines: 3,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  decoration: BoxDecoration(color: MyColors.grey, borderRadius: BorderRadius.circular(6)),
                  height: 30,
                  padding: EdgeInsets.all(6),
                  child: Center(
                    child: Row(
                      children: [
                        Icon(Icons.star, color: MyColors.yellow, size: 16),
                        SizedBox(width: 2),
                        Text(widget.ownerModel.getAverageRating().toStringAsFixed(2), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '${widget.ownerModel.placeRealAddress}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (userModel.savedPlaces.contains(widget.ownerModel.uid)) {
                      userModel.savedPlaces.remove(widget.ownerModel.uid);
                      await DatabaseService().removeSavedPlace(userModel.uid!, widget.ownerModel.uid!);
                    } else {
                      userModel.savedPlaces.add(widget.ownerModel.uid);
                      await DatabaseService().savePlace(userModel.uid!, widget.ownerModel.uid!);
                    }
                    userProvider.notify();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isSaved ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: isSaved ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${widget.ownerModel.contactInfo}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
