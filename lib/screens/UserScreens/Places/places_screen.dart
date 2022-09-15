import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/screens/UserScreens/PlaceDetail/place_detail.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  Widget build(BuildContext context) {
    PlacesProvider placesProvider = Provider.of<PlacesProvider>(context);
    List<OwnerModel> places = placesProvider.places;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                MyAppBar(
                  title: 'Mağazalar',
                  showBackButton: true,
                ),
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
          ),
        ),
      ),
    );
  }
}
