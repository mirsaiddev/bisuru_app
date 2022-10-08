import 'package:bi_suru_app/main.dart';
import 'package:bi_suru_app/screens/Splash/splash_screen.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            MyAppBar(title: 'Bağlantı Hatası', showBackButton: false),
            SizedBox(height: 10),
            Expanded(
              child: MyListTile(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('İnternet bağlantısı bekleniyor'),
                      ],
                    ),
                    SizedBox(height: 20),
                    MyButton(
                      text: 'Yeniden Dene',
                      onPressed: () async {
                        ConnectivityResult result = await Connectivity().checkConnectivity();
                        if (result != ConnectivityResult.none) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (val) => false);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
