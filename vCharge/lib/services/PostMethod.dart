import 'package:http/http.dart' as http;

class PostMethod{

  // this method is used to add a new model
  static Future<int> postRequest(String url, dynamic body) async {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
      body: body
    );
    if(response.statusCode == 200){
      // print('Post Successful');
      return response.statusCode;
    }else{
      // print('Error: ${response.statusCode}');
      return response.statusCode;
    }
  }

  // this method is used to add a new model
  static Future<http.Response> postRequestMod(String url, dynamic body) async {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
      body: body
    );
    return response;
  }
}