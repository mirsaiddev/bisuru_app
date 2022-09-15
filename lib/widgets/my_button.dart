import 'package:bi_suru_app/theme/colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    this.color = MyColors.red,
    required this.text,
    this.onPressed,
    this.height = 44,
    this.width = double.infinity,
  }) : super(key: key);

  final Color color;
  final String text;
  final void Function()? onPressed;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
