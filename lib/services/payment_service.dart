import 'dart:convert';

import 'package:bi_suru_app/utils/enums/payment_enums.dart';
import 'package:dio/dio.dart';

Map<PaymentType, String> paymentTypeMap = {
  PaymentType.user1Month: '9e867ec5-018c-43b0-baf9-a98876134c76',
  PaymentType.user3Months: '411c8538-d6a5-4e11-b789-21187ef58e74',
};

class PaymentService {
  Dio dio = Dio()..options.baseUrl = 'https://bisurum.com';

  Future<Map> payment({
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
    Map data = {
      'odeme_plani_referans_kodu': paymentTypeMap[paymentType],
      'kart_ad_soyad': cardNameSurname,
      'kart_numarasi': cardNo,
      'kart_son_kullanma_ayi': cardMonth,
      'kart_son_kullanma_yili': cardYear,
      'kart_cvc': cardCvc,
      'ad': name,
      'soyad': surname,
      'telefon': phone,
      'mail': mail,
      'tc_numarasi': tc,
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
    };

    Response response = await dio.post(
      '/odeme-alma.php',
      data: data,
    );

    print('response status code: ${response.statusCode}');
    print('response: ${response.data}');

    if (response.statusCode == 200) {
      if (jsonDecode(response.data)['status'] == 'error') {
        return {'success': false, 'message': jsonDecode(response.data)['response']};
      }
      return {'success': true, 'message': 'Başarılı'};
    } else {
      return {'success': false, 'message': response.data};
    }
  }
}
