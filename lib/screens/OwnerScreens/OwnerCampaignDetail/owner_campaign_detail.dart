import 'package:bi_suru_app/models/campaign.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnerCampaignDetail extends StatefulWidget {
  const OwnerCampaignDetail({Key? key, required this.campaign}) : super(key: key);

  final Campaign campaign;

  @override
  State<OwnerCampaignDetail> createState() => _OwnerCampaignDetailState();
}

class _OwnerCampaignDetailState extends State<OwnerCampaignDetail> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    OwnerModel ownerModel = userProvider.ownerModel!;
    Campaign campaign = widget.campaign;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            MyAppBar(title: campaign.campaignName, showBackButton: true),
            SizedBox(height: 10),
            MyListTile(
              child: ListTile(title: Text('Kampanya Adı'), subtitle: Text(campaign.campaignName)),
            ),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 2 / 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerCampaignDetail(campaign: campaign)));
                    },
                    child: Container(
                      child: Image.network(campaign.campaignImage, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            if (!campaign.ownerModels.any((element) => element == ownerModel.uid))
              MyButton(
                text: 'Kampanyaya Katıl',
                onPressed: () async {
                  await DatabaseService().joinToCampaign(campaign: campaign, ownerUid: ownerModel.uid!);
                  campaign.ownerModels.add(ownerModel);
                  MySnackbar.show(context, message: 'Kampanyaya katıldınız');
                },
              )
            else
              MyButton(
                text: 'Kampanyaya Katılıyorsunuz',
                onPressed: () {},
              ),
          ]),
        ),
      ),
    );
  }
}
