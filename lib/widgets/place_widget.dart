import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/UserScreens/PlaceDetail/place_detail.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceWidget extends StatefulWidget {
  const PlaceWidget({
    Key? key,
    required this.ownerModel,
    this.useFree = false,
  }) : super(key: key);

  final OwnerModel ownerModel;
  final bool useFree;

  @override
  State<PlaceWidget> createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
    bool isSaved = userModel.savedPlaces.contains(widget.ownerModel.uid);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetail(ownerModel: widget.ownerModel, useFree: widget.useFree),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                Text(
                  widget.ownerModel.placeDescription!,
                  maxLines: 3,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.ownerModel.placeName!,
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
                )
              ],
            ),
          ),
        ),
        if (widget.ownerModel.premium)
          Positioned(
            right: 6,
            top: 6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: Icon(Icons.star, color: MyColors.yellow, size: 26),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
