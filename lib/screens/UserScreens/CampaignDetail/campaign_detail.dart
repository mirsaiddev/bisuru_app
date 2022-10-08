import 'package:bi_suru_app/models/campaign.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/place_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CampaignDetail extends StatefulWidget {
  const CampaignDetail({Key? key, required this.campaign}) : super(key: key);

  final Campaign campaign;

  @override
  State<CampaignDetail> createState() => _CampaignDetailState();
}

class _CampaignDetailState extends State<CampaignDetail> {
  @override
  Widget build(BuildContext context) {
    Campaign campaign = widget.campaign;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: campaign.campaignName, showBackButton: true),
              SizedBox(height: 10),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: campaign.ownerModels.length,
                itemBuilder: (context, index) {
                  String ownerUid = campaign.ownerModels[index];
                  return StreamBuilder<DatabaseEvent>(
                      stream: DatabaseService().ownerModelStream(ownerUid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox();
                        }
                        if (snapshot.data!.snapshot.value == null) {
                          return SizedBox();
                        }
                        OwnerModel ownerModel = OwnerModel.fromJson(snapshot.data!.snapshot.value as Map);
                        return PlaceWidget(ownerModel: ownerModel);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
