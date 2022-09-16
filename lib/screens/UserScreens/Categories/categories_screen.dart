import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/CategoryPlaces/category_places.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context);
    List<String> categories = systemProvider.categories;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyAppBar(title: 'Kategoriler', showBackButton: false),
                SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
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
                          width: 80,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  category,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
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
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
