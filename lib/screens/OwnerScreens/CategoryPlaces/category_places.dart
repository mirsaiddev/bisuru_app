import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPlaces extends StatefulWidget {
  const CategoryPlaces({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<CategoryPlaces> createState() => _CategoryPlacesState();
}

class _CategoryPlacesState extends State<CategoryPlaces> {
  @override
  Widget build(BuildContext context) {
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context);
    List<OwnerModel> places = placesProvider.getPlacesForCategory(widget.category);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            MyAppBar(title: widget.category, showBackButton: true),
            SizedBox(height: 10),
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
      )),
    );
  }
}
