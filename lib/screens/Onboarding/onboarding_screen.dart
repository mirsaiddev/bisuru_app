import 'package:bi_suru_app/screens/UserScreens/Login/login_screen.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List onboardingData = [
    {
      'color': MyColors.red,
      'image': 'lib/assets/images/onboarding1.png',
      'title': 'Bisürü Kullan Kolayca Alışveriş Yap!',
      'description':
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae.',
    },
    {
      'color': MyColors.blue,
      'image': 'lib/assets/images/onboarding2.png',
      'title': 'Bisürü Kullan Kolayca Alışveriş Yap!',
      'description':
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae.',
    },
    {
      'color': MyColors.green,
      'image': 'lib/assets/images/onboarding3.png',
      'title': 'Bisürü Kullan Kolayca Alışveriş Yap!',
      'description':
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae.',
    },
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Builder(builder: (context) {
        Map data = onboardingData[currentIndex];
        Color color = data['color'];
        String image = data['image'];
        String title = data['title'];
        String description = data['description'];

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: height / 1.7,
                width: width,
                decoration: BoxDecoration(color: color.withOpacity(0.05)),
              ),
            ),
            SafeArea(
              child: Container(
                  child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyLogoWidgetColored(radius: 22, padding: 8, color: color),
                      SizedBox(width: 10),
                      Text('BiSürü', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColors.black)),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40), child: Image.asset(image)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.black, fontSize: 16), textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        Text(description, style: TextStyle(color: MyColors.black, fontSize: 12), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    color: color,
                    text: 'İleri',
                    width: 130,
                    onPressed: () {
                      if (currentIndex < onboardingData.length - 1) {
                        setState(() {
                          currentIndex++;
                        });
                      } else {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < onboardingData.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CircleAvatar(radius: 4, backgroundColor: currentIndex == i ? color : Colors.grey[300]),
                        ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              )),
            ),
          ],
        );
      }),
    );
  }
}
