import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/Splash/splash_screen.dart';
import 'package:bi_suru_app/screens/UserScreens/Places/places_screen.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
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
    List<OwnerModel> places = placesProvider.places;
    List<String> categories = systemProvider.categories;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLogoWidgetColored(radius: 20, padding: 8),
                SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                            aspectRatio: 2 / 1, child: Container(child: Image.network(systemProvider.sliders[index % systemProvider.sliders.length]))),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kategoriler', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                  ],
                ),
                SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (String category in categories)
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 10),
                          width: 80,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Container(
                              //   height: 60,
                              //   width: 60,
                              //   decoration: BoxDecoration(
                              //     color: Colors.red,
                              //     borderRadius: BorderRadius.circular(6),
                              //   ),
                              // ),
                              Flexible(
                                child: Text(
                                  category,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                placesProvider.getPlaceCountForCategory(category).toString(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sana Özel Hizmetler', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlacesScreen()));
                        },
                        child: Text('Tümünü Gör'))
                  ],
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    OwnerModel ownerModel = places[index];
                    return PlaceWidget(ownerModel: ownerModel);
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
