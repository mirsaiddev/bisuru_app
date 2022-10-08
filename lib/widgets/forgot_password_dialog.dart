import 'package:bi_suru_app/services/auth_service.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  String? email;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'E-posta adresinizi giriniz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            MyTextfield(
              hintText: "Email",
              onChanged: (value) {
                email = value;
              },
            ),
            SizedBox(height: 10),
            MyButton(
              text: 'Gönder',
              onPressed: () {
                if (email != null) {
                  AuthService().sendPasswordLink(email!);
                  Navigator.pop(context);
                  MySnackbar.show(context, message: 'Şifre sıfırlama linki gönderildi');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
