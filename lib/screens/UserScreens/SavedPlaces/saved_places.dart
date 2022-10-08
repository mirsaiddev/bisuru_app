import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedPlaces extends StatefulWidget {
  const SavedPlaces({Key? key}) : super(key: key);

  @override
  State<SavedPlaces> createState() => _SavedPlacesState();
}

class _SavedPlacesState extends State<SavedPlaces> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'Kaydedilenler', showBackButton: false),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<DatabaseEvent>(
                    stream: DatabaseService().savedPlacesStream(userModel.uid!),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return SizedBox();
                      }
                      if (snapshot.data!.snapshot.value == null) {
                        return Expanded(child: Center(child: Text('Kaydedilen yer bulunamadı')));
                      }
                      Map data = snapshot.data!.snapshot.value as Map;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<OwnerModel>(
                            future: DatabaseService().getOwnerModelById(data.entries.toList()[index].value),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              return PlaceWidget(ownerModel: snapshot.data!);
                            },
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
