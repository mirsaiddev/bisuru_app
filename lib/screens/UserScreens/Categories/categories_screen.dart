import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/screens/OwnerScreens/CategoryPlaces/category_places.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyAppBar(title: 'Kategoriler', showBackButton: false),
                SizedBox(height: 10),
                MyListTile(
                  child: MyTextfield(
                    fillColor: Colors.white,
                    hintText: 'Kategori Ara',
                    onChanged: (text) {
                      setState(() {
                        searchText = text;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                StreamBuilder<DatabaseEvent>(
                    stream: DatabaseService().categoriesStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      }
                      List categories = (snapshot.data!.snapshot.value as List).where((element) => element != null).toList();
                      return GridView.count(
                        shrinkWrap: true,
                        mainAxisSpacing: 8,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        children: [
                          for (String category in categories.where((element) => element.toLowerCase().contains(searchText.toLowerCase())))
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      category.getIcon(),
                                      height: 40,
                                    ),
                                    Flexible(
                                      child: Text(
                                        category,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      placesProvider.getPlaceCountForCategory(category).toString(),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
