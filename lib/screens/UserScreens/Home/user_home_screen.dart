import 'package:bi_suru_app/models/campaign.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/bottom_nav_bar_provider.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/CategoryPlaces/category_places.dart';
import 'package:bi_suru_app/screens/UserScreens/CampaignDetail/campaign_detail.dart';
import 'package:bi_suru_app/screens/UserScreens/Places/places_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Search/search_screen.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyLogoWidgetColored(radius: 20, padding: 8),
                        SizedBox(width: 6),
                        Text('BiSürü', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context, listen: false);
                        bottomNavBarProvider.setCurrentIndex(3);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Image.asset('lib/assets/images/location.png', width: 14),
                            SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lokasyonunuz', style: TextStyle(fontSize: 8)),
                                Text(userModel.city, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                MyTextfield(
                  hintText: 'Mekan Ara',
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  readOnly: true,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                  },
                ),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      Campaign campaign = systemProvider.campaigns[index % systemProvider.campaigns.length];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 2 / 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetail(campaign: campaign)));
                            },
                            child: Container(
                              child: Image.network(campaign.campaignImage, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kategoriler', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                    TextButton(
                        onPressed: () {
                          BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context, listen: false);
                          bottomNavBarProvider.setCurrentIndex(1);
                        },
                        child: Text('Tümünü Gör'))
                  ],
                ),
                SizedBox(height: 14),
                StreamBuilder<DatabaseEvent>(
                    stream: DatabaseService().categoriesStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      }
                      List categories = (snapshot.data!.snapshot.value as List).where((element) => element != null).toList();
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (String category in categories)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPlaces(category: category)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(right: 10),
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          category.getIcon(),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Flexible(
                                        child: Text(
                                          category,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        placesProvider.getPlaceCountForCategory(category).toString(),
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sana Özel Hizmetler', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlacesScreen()));
                      },
                      child: Text('Tümünü Gör'),
                    ),
                  ],
                ),
                StreamBuilder<DatabaseEvent>(
                  stream: DatabaseService().allPlacesStream(userModel.city),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                      return SizedBox();
                    }
                    List<OwnerModel> places = (snapshot.data!.snapshot.value as Map)
                        .entries
                        .map((e) => OwnerModel.fromJson(e.value))
                        .where((element) => element.placeIsOpen())
                        .toList();
                    places.sort((a, b) => b.references.length.compareTo(a.references.length));

                    placesProvider.places = places;
                    List<OwnerModel> premiumUsers = places.where((element) => element.premium).toList();
                    premiumUsers.sort((a, b) => b.references.length.compareTo(a.references.length));
                    List<OwnerModel> normalUsers = places.where((element) => !element.premium).toList();
                    normalUsers.sort((a, b) => b.references.length.compareTo(a.references.length));
                    places = premiumUsers + normalUsers;
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        OwnerModel ownerModel = places[index];
                        return PlaceWidget(ownerModel: ownerModel);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
