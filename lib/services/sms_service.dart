import 'package:http/http.dart' as http;

class SmsService {
  Future<void> send({required String number, required String text, String sender = 'HALISAHABAK'}) async {
    String baseUrl = "https://api.iletimerkezi.com/v1/send-sms/get/?username=5438755396&password=Halisaha0.&text=${text}&receipents=$number&sender=$sender";

    http.Response response = await http.get(Uri.parse(baseUrl));

    print(response.body);
    print(response.statusCode);
  }
}
