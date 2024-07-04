import '../domain/entities/user_entity.dart';
import '../domain/repositories/ user_repository.dart';
import '../infraestructure/services/local_storage_service.dart';
import '../infraestructure/services/network_service.dart';
import '../infraestructure/repositories/api_user_repository.dart';

abstract class UserRepositoryImpl implements UserRepository {
  final NetworkService _networkService;
  final LocalStorageService _localStorageService;
  final ApiUserRepository _apiUserRepository;

  UserRepositoryImpl(this._networkService, this._localStorageService, this._apiUserRepository);

  @override
  Future<bool> loginUser(User user) async {
    bool success = false;
    if (await _networkService.hasValidConnection()) {
      success = await _apiUserRepository.loginUser(user);
      if (success) {
        await _localStorageService.processPendingTransactions(_apiUserRepository);
      }
    } else {
      success = await _localStorageService.loginUserLocally(user);
    }
    return success;
  }

  @override
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    Map<String, dynamic> userDetails;
    if (await _networkService.hasValidConnection()) {
      userDetails = await _apiUserRepository.getUserDetails(userId);
      if (userDetails != null) {
        await _localStorageService.processPendingTransactions(_apiUserRepository);
      }
    } else {
      userDetails = await _localStorageService.getUserDetailsLocally(userId);
    }
    return userDetails;
  }

  @override
  Future<bool> updateUserInfo(String userId, Map<String, dynamic> newData) async {
    bool success = false;
    if (await _networkService.hasValidConnection()) {
      success = await _apiUserRepository.updateUserInfo(userId, newData);
      if (success) {
        await _localStorageService.processPendingTransactions(_apiUserRepository);
      }
    } else {
      success = await _localStorageService.updateUserInfoLocally(userId, newData);
    }
    return success;
  }

  @override
  Future<bool> deleteUserAccount(String userId) async {
    bool success = false;
    if (await _networkService.hasValidConnection()) {
      success = await _apiUserRepository.deleteUserAccount(userId);
      if (success) {
        await _localStorageService.processPendingTransactions(_apiUserRepository);
      }
    } else {
      success = await _localStorageService.deleteUserAccountLocally(userId);
    }
    return success;
  }

}