import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReferencesScreen extends StatefulWidget {
  const ReferencesScreen({Key? key}) : super(key: key);

  @override
  State<ReferencesScreen> createState() => _ReferencesScreenState();
}

class _ReferencesScreenState extends State<ReferencesScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    OwnerModel ownerModel = userProvider.ownerModel!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'Referanslar', showBackButton: false),
              SizedBox(height: 10),
              StreamBuilder<DatabaseEvent>(
                stream: DatabaseService().referencesStream(ownerModel.uid!),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox();
                  }
                  Map referencesMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                  List<String> references = referencesMap.entries.map((e) => e.value.toString()).toList();

                  return Column(
                    children: [
                      for (String referenceUid in references)
                        StreamBuilder<DatabaseEvent>(
                          stream: DatabaseService().userStream(referenceUid),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return SizedBox();
                            }
                            Map userMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                            UserModel userModel = UserModel.fromJson(userMap);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: MyListTile(
                                child: Row(
                                  children: [
                                    userModel.profilePicUrl != null
                                        ? ClipRRect(
                                            child: Image.network(userModel.profilePicUrl!, height: 50, width: 50), borderRadius: BorderRadius.circular(10))
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(color: MyColors.grey, borderRadius: BorderRadius.circular(10)),
                                            child: Center(child: Icon(Icons.person)),
                                          ),
                                    SizedBox(width: 10),
                                    Text(userModel.fullName),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
