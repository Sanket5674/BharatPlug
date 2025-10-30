import 'package:http/http.dart' as http;

class PutMethod {
  // this method is used to update the already existed object

  static Future<int> putRequest(String url, String id, var body) async {
    var response = await http.put(Uri.parse(url + id),
        headers: {'Content-Type': 'application/json'}, body: body);
    return response.statusCode;
  }

  static Future<http.Response> putRequestMod(
      String url, String id, var body) async {
    var response = await http.put(Uri.parse(url + id),
        headers: {'Content-Type': 'application/json'}, body: body);
    return response;
  }
}
