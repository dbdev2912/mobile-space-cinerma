import 'dart:convert';
import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {
    "Content-type": "Application/json"
  };

  Future<Map> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> post(String url, dynamic data) async {
    http.Response response =
    await http.post(Uri.parse(url), body: data, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> delete(String url) async {
    http.Response response =
    await http.delete(Uri.parse(url), headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['Cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}