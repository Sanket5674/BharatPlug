import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<ConnectivityResult> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult;
  }
}
