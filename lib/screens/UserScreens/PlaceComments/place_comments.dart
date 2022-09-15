import 'package:bi_suru_app/models/comment_model.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceComments extends StatefulWidget {
  const PlaceComments({Key? key, required this.owner}) : super(key: key);
  final OwnerModel owner;

  @override
  State<PlaceComments> createState() => _PlaceCommentsState();
}

class _PlaceCommentsState extends State<PlaceComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'Yorumlar', showBackButton: true),
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
                            Text(widget.owner.getAverageRating().toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              for (CommentModel commentModel in widget.owner.comments)
                Column(
                  children: [
                    SizedBox(height: 10),
                    MyListTile(
                      padding: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(commentModel.senderName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          SizedBox(height: 6),
                          Text(commentModel.comment, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(commentModel.createDate.toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey[400])),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(commentModel.rating.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 6),
                                Icon(Icons.star, color: MyColors.yellow, size: 16),
                                Icon(Icons.star, color: MyColors.yellow, size: 16),
                                Icon(Icons.star, color: MyColors.yellow, size: 16),
                                Icon(Icons.star, color: MyColors.yellow, size: 16),
                                Icon(Icons.star, color: MyColors.grey, size: 16),
                              ]),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
