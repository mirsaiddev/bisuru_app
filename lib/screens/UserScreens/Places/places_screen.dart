import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/UserScreens/PlaceDetail/place_detail.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:firebase_database/firebase_database.dart';
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
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
