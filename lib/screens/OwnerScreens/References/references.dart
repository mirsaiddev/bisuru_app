import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/reference.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/date_formatters.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
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
          child: SingleChildScrollView(
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
                    List<Reference> references = referencesMap.entries.map((e) => Reference.fromMap(e.value as Map)).toList();
                    references.sort((a, b) => b.date.compareTo(a.date));
                    Map dates = {};

                    references.forEach((reservation) {
                      if (dates[reservation.date.daysDate()] == null) {
                        dates[reservation.date.daysDate()] = [];
                      }
                    });

                    references.forEach((element) {
                      dates[element.date.daysDate()].add(element);
                    });

                    List sortedKeys = dates.keys.toList()..sort((a, b) => b.compareTo(a));

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${(sortedKeys[index] as DateTime).toDateString()}', style: TextStyle(fontWeight: FontWeight.bold)),
                              Column(
                                children: [
                                  for (var reference in dates[sortedKeys[index]])
                                    StreamBuilder<DatabaseEvent>(
                                        stream: DatabaseService().userStream(reference.uid),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == null) {
                                            return SizedBox();
                                          }
                                          Map userMap = snapshot.data!.snapshot.value != null ? snapshot.data!.snapshot.value as Map : {};
                                          UserModel userModel = UserModel.fromJson(userMap);
                                          print('dates: $dates');
                                          return MyListTile(
                                            child: Row(
                                              children: [
                                                userModel.profilePicUrl != null
                                                    ? ClipRRect(
                                                        child: Image.network(userModel.profilePicUrl!, height: 50, width: 50),
                                                        borderRadius: BorderRadius.circular(10))
                                                    : Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(color: MyColors.grey, borderRadius: BorderRadius.circular(10)),
                                                        child: Center(child: Icon(Icons.person)),
                                                      ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(userModel.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text(reference.productName),
                                                    ],
                                                  ),
                                                ),
                                                Text((reference.date as DateTime).toHour()),
                                              ],
                                            ),
                                          );
                                        }),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
