import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/news/payment_real_services.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/utils/enums/payment_enums.dart';
import 'package:bi_suru_app/utils/my_snackbar.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen({Key? key, required this.paymentType}) : super(key: key);

  final PaymentType paymentType;

  @override
  State<UserPaymentScreen> createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
  String cardNumber = '5400617007286848';
  String expiryDate = '04/2026';
  String cardHolderName = 'Muhammed Yasir Canpolat';
  String cvvCode = '651';
  bool isCvvFocused = false;
  bool useGlassMorphism = true;
  bool useBackgroundImage = true;
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel userModel = userProvider.userModel!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(title: 'Ödeme', showBackButton: false),
              SizedBox(height: 10),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                height: 200,
                textStyle: TextStyle(color: Colors.white),
                width: MediaQuery.of(context).size.width,
                isChipVisible: true,
                isSwipeGestureEnabled: true,
                cardBgColor: MyColors.red,
                animationDuration: Duration(milliseconds: 1000),
                onCreditCardWidgetChange: (CreditCardBrand) {},
                cardType: CardType.mastercard,
              ),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: false,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                themeColor: MyColors.red,
                textColor: Colors.black,
                cvvValidationMessage: 'CVV kodu 3 karakter olmalıdır',
                numberValidationMessage: 'Kart numarası 16 karakter olmalıdır',
                dateValidationMessage: 'Geçerli bir tarih giriniz',
                cursorColor: MyColors.red,
                cardNumberDecoration: decoration(
                  labelText: 'Kart Numarası',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: decoration(
                  labelText: 'Bitiş Tarihi',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: decoration(
                  labelText: 'Güvenlik Kodu',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: decoration(
                  labelText: 'Kart Sahibi Adı',
                  hintText: 'Ad Soyad',
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: MyButton(
                    text: 'Ödeme Yap',
                    onPressed: () async {
                      String phone = '+90' + userModel.phone.replaceAll(' ', '');
                      print('phone number: ${phone}');
                      Map response = await PaymentServiceTwo().payment(
                        paymentType: widget.paymentType,
                        cardNameSurname: cardHolderName,
                        cardNo: cardNumber,
                        cardMonth: expiryDate.split('/').first,
                        cardYear: expiryDate.split('/').last,
                        cardCvc: cvvCode,
                        name: cardHolderName.split(' ').first,
                        surname: cardHolderName.split(' ').last,
                        phone: phone,
                        mail: 'deneme@gmail.com',
                        faturaNameSurname: userModel.fullName,
                        faturaCity: userModel.city,
                        faturaCountry: 'Türkiye',
                        faturaAddress: 'Türkiye / ${userModel.city}',
                        faturaPostalCode: '06320',
                      );
                      if (response['status'] == 'success') {
                        userModel.premium = true;
                        userProvider.notify();
                        await DatabaseService().buyPremium(isUser: true, uid: userModel.uid!);
                        Navigator.pop(context);
                        MySnackbar.show(context, message: 'Abonelik başlatıldı');
                      } else {
                        MySnackbar.show(context, message: 'Ödeme sırasında bir hata oluştu : ${response['response']}');
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration decoration({required String labelText, required String hintText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: MyColors.red),
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
