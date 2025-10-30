/*

---------------------- File for future purpose of encoding and decoding after one scans the qr code

*/

import 'dart:convert';

String decrypt(String encodedMsg) {
  //print("the encoded message is: $encodedMsg");

  String decodedMsg = utf8.decode(base64.decode(encodedMsg));
  //print("The decoded message is: $decodedMsg");
  return decodedMsg;
}
