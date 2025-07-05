import 'package:http/http.dart' as http;
import 'dart:convert';


class API_service {
  String API_URL = "http://10.0.2.2:5000/";

  Future<List<dynamic>> fetchAllServices() async {
    API_service url = API_service();
    final response = await http.get(Uri.parse("${url.API_URL}/service/get_services"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load services");
    }
  }

}