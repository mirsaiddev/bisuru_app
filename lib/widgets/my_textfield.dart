import 'package:bi_suru_app/theme/colors.dart';
import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({
    Key? key,
    this.text,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.hintText,
    this.suffixText,
    this.prefixText,
    this.onChanged,
    this.fillColor = MyColors.lightGrey,
  }) : super(key: key);

  final String? text;
  final String? hintText;
  final String? suffixText;
  final String? prefixText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null) ...[
          Text(text!),
          SizedBox(height: 6),
        ],
        SizedBox(
          child: TextFormField(
            onChanged: onChanged,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              suffixText: suffixText,
              prefixText: prefixText,
              prefixStyle: TextStyle(color: MyColors.red),
              contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              fillColor: fillColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
