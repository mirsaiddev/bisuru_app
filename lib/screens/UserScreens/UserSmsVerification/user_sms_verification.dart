import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/sms_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class UserSmsVerification extends StatefulWidget {
  const UserSmsVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<UserSmsVerification> createState() => _UserSmsVerificationState();
}

class _UserSmsVerificationState extends State<UserSmsVerification> {
  TextEditingController phoneController = TextEditingController();
  bool sent = false;
  String code = '';

  @override
  void initState() {
    super.initState();
    getPhone();
  }

  void getPhone() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel? userModel = userProvider.userModel;
    if (userModel != null) {
      phoneController.text = userModel.phone;
    }
  }

  Future<void> sendSms() async {
    code = randomNumeric(6);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel? userModel = userProvider.userModel;
    await SmsService().send(number: userModel!.phone, text: 'Bi Sürü SMS Doğrulama Kodunuz: $code');
    sent = true;
    setState(() {});
  }

  void verify() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel? userModel = userProvider.userModel;
    DatabaseService().verifySms(isUser: true, uid: userModel!.uid!);
    userModel.smsVerified = true;
    userProvider.setUserModel(userModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'SMS Doğrulaması', showBackButton: false),
              SizedBox(height: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyListTile(
                      child: Row(
                        children: [
                          Expanded(
                            child: InternationalPhoneNumberInput(
                              isEnabled: false,
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              spaceBetweenSelectorAndTextField: 0,
                              inputDecoration: InputDecoration(
                                hintText: '5XX',
                                isDense: true,
                                prefixStyle: TextStyle(color: MyColors.red),
                                contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                fillColor: MyColors.lightGrey,
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
                              onInputChanged: (val) {},
                              locale: 'TR',
                              errorMessage: 'Hatalı telefon numarası',
                              textFieldController: phoneController,
                              initialValue: PhoneNumber(isoCode: 'TR'),
                            ),
                          ),
                          if (!sent) ...[
                            SizedBox(width: 10),
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: MyButton(
                                text: 'Gönder',
                                onPressed: sendSms,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (sent)
                      MyListTile(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text('Telefon numaranıza gelen 6 haneli kodu giriniz.'),
                            SizedBox(height: 10),
                            Pinput(
                              length: 6,
                              controller: TextEditingController(),
                              defaultPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
                                decoration: BoxDecoration(
                                  color: MyColors.lightGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              submittedPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
                                decoration: BoxDecoration(
                                  color: MyColors.lightGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (val) {
                                if (val.length == 6) {
                                  if (code.length == 6 && val == code) {
                                    verify();
                                  } else {
                                    MySnackbar.show(context, message: 'Doğrulama kodu hatalı');
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
