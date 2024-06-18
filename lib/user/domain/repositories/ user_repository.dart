import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<bool> loginUser(User user);
  Future<Map<String, dynamic>> getUserDetails(String userId);
  Future<bool> updateUserInfo(String userId, Map<String, dynamic> newData);
  Future<bool> deleteUserAccount(String userId);
  Future<bool> registerUser(User user); // Agrega este método para registrar un usuario
  Future<List<User>> listUsers(); // Método para listar todos los usuarios
}



