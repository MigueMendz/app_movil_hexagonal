import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<bool> loginUser(User user);
  Future<Map<String, dynamic>> getUserDetails(String userId);
  Future<bool> updateUserInfo(String userId, Map<String, dynamic> newData);
  Future<bool> deleteUserAccount(String userId);
  }



