import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url); // url로부터 데이터를 가져옴

    if (response.statusCode == 200) {

      String data = utf8.decode(response.bodyBytes); // 한글깨져서 ut8로 인코딩해야됨!! 필수!!
      var decodedData = jsonDecode(data); // decoding

      return decodedData;
    } else {
      print(response.statusCode);
    }
  }
}
