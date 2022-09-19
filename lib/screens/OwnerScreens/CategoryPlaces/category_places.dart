import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
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
  List<OwnerModel> places = [];
  List<OwnerModel> searchedPlaces = [];
  bool searched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPlaces();
    });
  }

  void search(String text) {
    if (text.trim().isEmpty) {
      searched = false;
      setState(() {});
      return;
    }
    searched = true;
    searchedPlaces = places.where((element) {
      bool samePlaceName = element.placeName != null && element.placeName!.toLowerCase().contains(text.toLowerCase());
      bool sameName = element.name.toLowerCase().contains(text.toLowerCase());
      return sameName || samePlaceName;
    }).toList();
    setState(() {});
  }

  void getPlaces() {
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    placesProvider.getAllPlaces(userProvider.userModel!.city);
    places = placesProvider.getPlacesForCategory(widget.category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            MyAppBar(title: widget.category, showBackButton: true),
            SizedBox(height: 10),
            MyTextfield(
              hintText: 'Mekan Adı',
              suffixIcon: Icon(Icons.search),
              fillColor: Colors.white,
              onChanged: (val) {
                search(val);
              },
            ),
            SizedBox(height: 10),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: searched ? searchedPlaces.length : places.length,
              itemBuilder: (context, index) {
                OwnerModel ownerModel = searched ? searchedPlaces[index] : places[index];
                return PlaceWidget(ownerModel: ownerModel);
              },
            ),
          ],
        ),
      )),
    );
  }
}
