import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/ user_repository.dart';
import '../services/network_service.dart';
import '../services/local_storage_service.dart';

class ApiUserRepository implements UserRepository {
  final String baseUrl;
  final NetworkService _networkService;
  final LocalStorageService _localStorageService;

  ApiUserRepository(this.baseUrl, this._networkService, this._localStorageService);

  @override
  Future<bool> loginUser(User user) async {
    try {
      if (await _networkService.hasValidConnection()) {
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
          return true;
        } else {
          return false;
        }
      } else {
        return await _localStorageService.loginUserLocally(user);
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      if (await _networkService.hasValidConnection()) {
        final response = await http.get(
          Uri.parse('$baseUrl/get_user_email/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          return {};
        }
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  @override
  Future<bool> updateUserInfo(String userId, Map<String, dynamic> newData) async {
    try {
      if (await _networkService.hasValidConnection()) {
        final response = await http.put(
          Uri.parse('$baseUrl/update_user_email/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(newData),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return await _localStorageService.updateUserInfoLocally(userId, newData);
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUserAccount(String userId) async {
    try {
      if (await _networkService.hasValidConnection()) {
        final response = await http.delete(
          Uri.parse('$baseUrl/delete_user_email/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return await _localStorageService.deleteUserAccountLocally(userId);
      }
    } catch (e) {
      return false;
    }
  }
}
