import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/ user_repository.dart';
import '../models/user_model.dart';

class ApiUserRepository implements UserRepository {
  final String baseUrl = 'http://192.168.56.1:3002';

  @override
  Future<bool> loginUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': user.email,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200) {
        // Verifica la respuesta de la API y devuelve true si el inicio de sesión es correcto
        return true;
      } else {
        // Si el código de estado no es 200, devuelve false
        return false;
      }
    } catch (e) {
      // En caso de excepción, también devuelve false
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_user_email/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Retorna los detalles del usuario en forma de mapa
        return jsonDecode(response.body);
      } else {
        // Si el código de estado no es 200, retorna un mapa vacío
        return {};
      }
    } catch (e) {
      // En caso de excepción, retorna un mapa vacío
      return {};
    }
  }

  @override
  Future<bool> updateUserInfo(String userId, Map<String, dynamic> newData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update_user_email/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newData),
      );

      if (response.statusCode == 200) {
        // Retorna true si la actualización fue exitosa
        return true;
      } else {
        // Si el código de estado no es 200, retorna false
        return false;
      }
    } catch (e) {
      // En caso de excepción, retorna false
      return false;
    }
  }

  @override
  Future<bool> deleteUserAccount(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete_user_email/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Retorna true si la eliminación fue exitosa
        return true;
      } else {
        // Si el código de estado no es 200, retorna false
        return false;
      }
    } catch (e) {
      // En caso de excepción, retorna false
      return false;
    }
  }
}
