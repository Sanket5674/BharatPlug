import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DeleteMethod {
  // this method handles the delete request with respect to the specific id:
  // this method has been made static to make it available in complete project

  static Future<void> deleteRequest(BuildContext context, String url) async {
    try {
      var response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
      } else {
        //print("Error deleting: ${response.statusCode}");
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
    }
  }
}
