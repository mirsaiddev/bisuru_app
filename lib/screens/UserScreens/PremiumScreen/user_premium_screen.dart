import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/screens/UserScreens/PremiumScreen/user_payment_screen.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/payment_enums.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPremiumScreen extends StatefulWidget {
  const UserPremiumScreen({Key? key}) : super(key: key);

  @override
  State<UserPremiumScreen> createState() => _UserPremiumScreenState();
}

class _UserPremiumScreenState extends State<UserPremiumScreen> {
  @override
  Widget build(BuildContext context) {
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);
    double userPremium1MonthPrice = systemProvider.userPremium1MonthPrice;
    double userPremium3MonthPrice = systemProvider.userPremium3MonthPrice;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'Premium', showBackButton: true),
              SizedBox(height: 10),
              MyListTile(
                padding: 16,
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/shop.png',
                      height: 50,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'BiSürü Premium\nKullanıcımız Olun!',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              MyListTile(
                padding: 16,
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/done.png',
                      height: 26,
                    ),
                    SizedBox(width: 16),
                    Expanded(child: Text('Ürünlerin karekodunu açma')),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Planınızı Seçin',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: MyListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPaymentScreen(
                                paymentType: PaymentType.user1Month,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Image.asset('lib/assets/images/premium.png', height: 50),
                            SizedBox(height: 10),
                            Text(
                              '1 Aylık\nPremium Paket\n${userPremium1MonthPrice.toStringAsFixed(2)}₺',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MyColors.red2, MyColors.orange]),
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                padding: EdgeInsets.all(10),
                                child: Center(child: Text('Satın Al', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: MyListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserPaymentScreen(
                                        paymentType: PaymentType.user3Months,
                                      )));
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Image.asset('lib/assets/images/premium.png', height: 50),
                            SizedBox(height: 10),
                            Text(
                              '3 Aylık\nPremium Paket\n${userPremium3MonthPrice}₺',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MyColors.red2, MyColors.orange]),
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                padding: EdgeInsets.all(10),
                                child: Center(child: Text('Satın Al', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
