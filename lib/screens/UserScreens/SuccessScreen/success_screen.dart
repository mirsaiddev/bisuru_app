import 'package:bi_suru_app/utils/enums/payment_enums.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';

class SuccessScreem extends StatelessWidget {
  const SuccessScreem({Key? key, required this.paymentType}) : super(key: key);
  final PaymentType paymentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'Abonelik', showBackButton: true),
              SizedBox(height: 10),
              Expanded(
                child: MyListTile(
                  child: Column(
                    children: [
                      MyListTile(
                        child: Text(
                          paymentTypeNames[paymentType]!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
