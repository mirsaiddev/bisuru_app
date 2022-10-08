import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bi_suru_app/utils/enums/payment_enums.dart';
import 'package:dio/dio.dart';



Map<PaymentType, String> paymentTypeMap = {
  PaymentType.user1Month: 'd2ad4237-6ff8-4c3d-8019-0ddc0a8c61d1',
  PaymentType.user3Months: '411c8538-d6a5-4e11-b789-21187ef58e74',
};

class PaymentServiceTwo{

  Future<dynamic> payment({
    required PaymentType paymentType,
    required String cardNameSurname,
    required String cardNo,
    required String cardMonth,
    required String cardYear,
    required String cardCvc,
    required String name,
    required String surname,
    required String phone,
    required String mail,
    String tc = '11111111111',
    required String faturaNameSurname,
    required String faturaCity,
    required String faturaCountry,
    required String faturaAddress,
    required String faturaPostalCode,
    String ownerNameSurname = 'Nurettin Eraslan',
    String ownerCity = 'Elazığ',
    String ownerCountry = 'Türkiye',
    String ownerAddress = 'Türkiye/Elazığ',
    String ownerPostalCode = '23350',
  }) async {

    http.Response response = await http.post(
      Uri.parse('https://bisurum.com/odeme-alma.php'),
      body: {
        'odeme_plani_referans_kodu': paymentTypeMap[paymentType],
        'cardName': cardNameSurname,
        'cardNumber': cardNo,
        'cardMonth': cardMonth,
        'cardYear': cardYear,
        'cardCvc': cardCvc,
        'ad': name,
        'soyad':surname,
        'telefon': phone,
        'mail': mail,

        'fatura_ad_soyad': faturaNameSurname,
        'fatura_sehir': faturaCity,
        'fatura_ulke': faturaCountry,
        'fatura_adres': faturaAddress,
        'fatura_posta_kodu': faturaPostalCode,
        'fatura_kesecek_ad_soyad': ownerNameSurname,
        'fatura_kesecek_sehir': ownerCity,
        'fatura_kesecek_ulke': ownerCountry,
        'fatura_kesecek_adres': ownerAddress,
        'fatura_kesecek_posta_kodu': ownerPostalCode,
        
        
         
        // 'paymentTransactionId': paymentTransactionId,
      },
    );
    print("phone: {$phone}");
    print(response.statusCode);
    print(response.body);

    return (jsonDecode(response.body));
  }
}