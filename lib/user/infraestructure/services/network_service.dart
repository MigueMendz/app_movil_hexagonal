import 'package:connectivity/connectivity.dart';
import '../../domain/repositories/ user_repository.dart';
import 'local_storage_service.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasValidConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void monitorConnection(LocalStorageService localStorageService, UserRepository userRepository) {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        await localStorageService.processPendingTransactions(userRepository);
      }
    });
  }
}
