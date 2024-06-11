import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/ user_repository.dart';

class LocalStorageService {
  List<Map<String, dynamic>> _pendingTransactions = [];

  Future<bool> loginUserLocally(User user) async {
    _pendingTransactions.add({
      'type': 'login',
      'data': {'email': user.email, 'password': user.password},
    });
    return true;
  }

  Future<bool> updateUserInfoLocally(String userId, Map<String, dynamic> newData) async {
    _pendingTransactions.add({
      'type': 'updateUserInfo',
      'data': {'userId': userId, 'newData': newData},
    });
    return true;
  }

  Future<bool> deleteUserAccountLocally(String userId) async {
    _pendingTransactions.add({
      'type': 'deleteUserAccount',
      'data': {'userId': userId},
    });
    return true;
  }

  Future<void> processPendingTransactions(UserRepository userRepository) async {
    for (var transaction in _pendingTransactions) {
      switch (transaction['type']) {
        case 'login':
          var data = transaction['data'];
          var user = User(email: data['email'], password: data['password']);
          await userRepository.loginUser(user);
          break;
        case 'updateUserInfo':
          var data = transaction['data'];
          await userRepository.updateUserInfo(data['userId'], data['newData']);
          break;
        case 'deleteUserAccount':
          var data = transaction['data'];
          await userRepository.deleteUserAccount(data['userId']);
          break;
        default:
          print('Unknown transaction type: ${transaction['type']}');
      }
    }
    _pendingTransactions.clear();
  }

  getUserDetailsLocally(String userId) {}

}
