// // this is the service for setting up the redis connection
//
// // import 'package:redis/redis.dart' as redis;
//
//
//
// // port
//
// // this is the class of redis connection
// class RedisConnection {
//   // variable for storing the serverIp and serverPort (6379)
//   static String serverIp = "192.168.0.241";
//   static int serverPort = 6379;
//
//   // function for setting up the redis connection and sending the GET request
//   static Future<dynamic> get(String key) async {
//     print("this is key : $key");
//     var redisClient = redis.RedisConnection();
//     try {
//       var conn = await redisClient.connect(serverIp, serverPort);
//       var response = conn.send_object(["GET", key]);
//       redisClient.close();
//       print("print the screen....");
//       return response;
//     } catch (e) {
//       print("Exception in get: $e");
//     }
//   }
//
//   // function for setting up the redis connection and also sending the SET request
//   static Future<void> set(String key, dynamic value) async {
//     var redisClient = redis.RedisConnection();
//     try {
//       var conn = await redisClient.connect(serverIp, serverPort);
//       conn.send_object(["SET", key, value]);
//     } catch (e) {
//       print("Exception in set $e");
//     }
//     redisClient.close();
//   }
// }
