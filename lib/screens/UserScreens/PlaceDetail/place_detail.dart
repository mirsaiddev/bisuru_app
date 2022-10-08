import 'package:bi_suru_app/models/comment_model.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/models/reference.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/UserScreens/AboutOwner/about_owner.dart';
import 'package:bi_suru_app/screens/UserScreens/MapsScreen/maps_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/PlaceAllProducts/place_all_products.dart';
import 'package:bi_suru_app/screens/UserScreens/PlaceComments/place_comments.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:bi_suru_app/widgets/product_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceDetail extends StatefulWidget {
  const PlaceDetail({Key? key, required this.ownerModel, this.useFree = false}) : super(key: key);

  final OwnerModel ownerModel;
  final bool useFree;

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
    bool isSaved = userModel.savedPlaces.contains(widget.ownerModel.uid);

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            MyAppBar(
              title: 'Mağaza Bilgileri',
              showBackButton: true,
              action: GestureDetector(
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
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: DatabaseService().ownerModelStream(widget.ownerModel.uid!),
                builder: (context, snapshot) {
                  OwnerModel ownerModel = widget.ownerModel;
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    ownerModel = OwnerModel.fromJson(snapshot.data!.snapshot.value as Map);
                  }
                  if (!ownerModel.placeIsOpen()) {
                    return Center(child: Text('Bu mekan henüz açılmamış'));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if (!ownerModel.enable) ...[
                          SizedBox(height: 10),
                          MyListTile(
                            padding: 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: double.infinity),
                                Text(
                                  'Uyarı!',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text(
                                  'Bu işletme şu anda kapalıdır.',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                                ),
                              ],
                            ),
                            color: MyColors.red,
                          ),
                          SizedBox(height: 10),
                        ],
                        AspectRatio(
                          aspectRatio: 2 / 1,
                          child: PageView.builder(
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 2 / 1,
                                  child: Container(
                                    child: Image.network(
                                      ownerModel.getImages()[index % ownerModel.getImages().length],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        MyListTile(
                          padding: 16,
                          child: Row(
                            children: [
                              Text(
                                ownerModel.placeName!,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (!ownerModel.references.any((element) => (element as Reference).uid == userModel.uid)) {
                                    MySnackbar.show(context, message: 'Bu mekana yorum yapmak için önce ürün satın almalısınız');
                                    return;
                                  }
                                  double? rating;
                                  String? comment;
                                  showCupertinoModalBottomSheet(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return Material(
                                          child: Container(
                                            height: 500,
                                            decoration: BoxDecoration(color: MyColors.grey),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                MyAppBar(title: 'Yorum Yap', showBackButton: false),
                                                SizedBox(height: 10),
                                                Expanded(
                                                  child: MyListTile(
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          RatingStars(
                                                            starSize: 30,
                                                            value: rating ?? 0,
                                                            valueLabelVisibility: false,
                                                            onValueChanged: (val) {
                                                              setState(() {
                                                                rating = val;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(height: 20),
                                                          MyTextfield(
                                                            hintText: 'Yorumunuz',
                                                            maxLines: 5,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                comment = val;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(height: 20),
                                                          MyButton(
                                                            text: 'Gönder',
                                                            onPressed: () async {
                                                              if (rating == null) {
                                                                MySnackbar.show(context, message: 'Lütfen puan verin');
                                                                return;
                                                              }
                                                              if (comment == null || comment!.isEmpty) {
                                                                MySnackbar.show(context, message: 'Lütfen yorumunuzu yazın');
                                                                return;
                                                              }
                                                              CommentModel commentModel = CommentModel(
                                                                comment: comment!,
                                                                rating: rating!.toInt(),
                                                                senderName: userModel.fullName,
                                                                createDate: DateTime.now(),
                                                              );
                                                              await DatabaseService().addComment(ownerModel.uid!, commentModel);
                                                              ownerModel.comments.add(commentModel);
                                                              setState(() {
                                                                rating = null;
                                                                comment = null;
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(color: MyColors.yellowLight, borderRadius: BorderRadius.circular(10)),
                                  height: 32,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: MyColors.yellow, size: 18),
                                      SizedBox(width: 6),
                                      Text('Yorum yap', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: MyColors.yellow)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        MyListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AboutOwner(ownerModel: ownerModel)));
                          },
                          padding: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mağaza Hakkında',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(ownerModel.placeDescription!)
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        MyListTile(
                          onTap: () async {
                            String url = 'tel:${widget.ownerModel.contactInfo}';
                            bool canLaunch = await canLaunchUrlString(url);
                            if (canLaunch) {
                              launchUrlString(url);
                            }
                          },
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
                              Text(ownerModel.contactInfo ?? 'Henüz eklenmedi')
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        MyListTile(
                            child: Container(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapsScreen(ownerModel: ownerModel)));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset('lib/assets/images/gps.png', width: 30),
                                        Text(
                                          'Lokasyon',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PlaceComments(
                                                  owner: ownerModel,
                                                )));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset('lib/assets/images/comment.png', width: 30),
                                        Text(
                                          'Yorumlar',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(height: 10),
                        MyListTile(
                          padding: 16,
                          child: Row(
                            children: [
                              Text(
                                'Ödeme Yöntemleri',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all()),
                                height: 32,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Center(
                                  child: Text('VISA'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ürünler', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceAllProducts(ownerModel: ownerModel)));
                                },
                                child: Text('Tümünü Gör'))
                          ],
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ownerModel.products.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel = ownerModel.products[index];
                            return ProductTile(productModel: productModel, ownerModel: ownerModel, useFree: widget.useFree);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
