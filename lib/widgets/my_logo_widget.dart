import 'package:bi_suru_app/theme/colors.dart';
import 'package:flutter/material.dart';

class MyLogoWidget extends StatelessWidget {
  const MyLogoWidget({
    Key? key,
    this.radius = 30,
    this.padding = 12,
  }) : super(key: key);

  final double radius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Image.asset(
          'lib/assets/images/logo.png',
          color: MyColors.red2,
        ),
      ),
    );
  }
}

class MyLogoWidgetColored extends StatelessWidget {
  const MyLogoWidgetColored({
    Key? key,
    this.radius = 30,
    this.padding = 12,
    this.color = MyColors.red2,
  }) : super(key: key);

  final double radius;
  final double padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: radius,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Image.asset(
          'lib/assets/images/logo.png',
          color: Colors.white,
        ),
      ),
    );
  }
}
