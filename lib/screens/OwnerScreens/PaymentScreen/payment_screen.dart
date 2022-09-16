import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '5105105105105100';
  String expiryDate = '07/27';
  String cardHolderName = 'HALISAHABAK';
  String cvvCode = '171';
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
                child: MyButton(text: 'Ödeme Yap', onPressed: () {}),
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
