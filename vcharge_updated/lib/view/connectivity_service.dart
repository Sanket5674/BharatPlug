import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  /// Checks for network connectivity.
  /// Returns a single [ConnectivityResult] value based on the current status.
  Future<ConnectivityResult> checkConnectivity() async {
    // New API returns a list of results (e.g. [wifi, mobile])
    final results = await Connectivity().checkConnectivity();

    // Return the first active connection, or none if the list is empty.
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  /// Stream of connectivity changes.
  /// You can use this to listen for real-time network updates.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged;
}
