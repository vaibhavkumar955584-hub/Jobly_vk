import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get connectivityStream => _controller.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _controller.add(results.first);
      }
    });
  }

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
